//
//  NakedHubFeedCell.m
//  NakedHub
//
//  Created by 朱明 on 16/3/11.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedHubFeedCell.h"
#import "YYPhotoGroupView.h"
#import "NakedPerSonalDetailsViewController.h"
#import "Constant.h"
#import "Utility.h"
#import "NakedHubFeedDetailsViewController.h"
#import "SVWebViewController.h"
#import "NakedHubFeedListViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "ZXingObjC.h"

#define _FIValueBetween(value, min, max) ({ \
__typeof__(value) __value = (value); \
__typeof__(min) __min = (min); \
__typeof__(max) __max = (max); \
__value >= __min && __value <= __max; \
})

@interface NakedHubFeedCell ()

@property (nonatomic, strong) JTSImageViewController *imageViewer;

@end

@implementation NakedHubFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utility configSubView:self.headPortraitView CornerWithRadius:self.headPortraitView.frame.size.height/2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewBigImage:)];
    [self.feedImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapHeadPortraitView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClikeHeadPortraitView:)];
    [self.headPortraitView addGestureRecognizer:tapHeadPortraitView];
//    self.contentLabel.delegate = self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    

}
- (CGSize)sizeForJPEGWithData:(NSData *)data
{
    // JPEG parsing is a bit more elaborate then the others as the data we're looking for comes after
    // many different variably-sized data structures
    //
    // ELI5: JPEG file data structure includes a bunch of headers which mark certain type of info,
    // we want to find the header that holds the size.
    
    typedef NS_ENUM(NSInteger, _FIJPEGState) {
        _FIJPEGStateFindHeader,
        _FIJPEGStateDetermineFrameType,
        _FIJPEGStateSkipFrame,
        _FIJPEGStateFoundSOF,
        _FIJPEGStateFoundEOI
    };
    
    // Note: Height data comes before width data.  Also both are big-endian
    struct {
        UInt16 height; // Big-endian
        UInt16 width; // Big-endian
    } jpeg_size;
    
    // Start at offset 2 (knowing we already passed the first two bytes determining that this is a JPEG file)
    _FIJPEGState state = _FIJPEGStateFindHeader;
    UInt32 offset = 2;
    
    // Loop until we find what we want
    while (offset < data.length) {
        switch (state) {
                
            case _FIJPEGStateFindHeader: {
                // Find a table header. These are denoted by the bytes `FFXX`, where XX denotes the type of data in that
                // data table. If we parse this correctly, this loop will only run once.
                
                UInt8 sample = 0;
                while (sample != 0xFF) {
                    if (offset < data.length) {
                        [data getBytes:&sample range:NSMakeRange(offset, 1)];
                        offset++;
                    } else {
                        // If we parsed the whole chuck of data and couldn't find it?...
                        // Not enough data or a corrupted JPEG. Should error out here
                        return CGSizeZero;
                    }
                }
                
                // Move to determine the type of the table
                state = _FIJPEGStateDetermineFrameType;
                break;
            }
                
            case _FIJPEGStateDetermineFrameType: {
                // We've found a data marker, now we determine what type of data we're looking at.
                // FF E0 -> FF EF are 'APPn', and include lots of metadata like JFIF, EXIF, etc.
                //
                // What we want to find is one of the SOF (Start of Frame) header, cause' it includes
                // width and height (what we want!)
                //
                // JPEG Metadata Header Table
                // http://www.xbdev.net/image_formats/jpeg/tut_jpg/jpeg_file_layout.php
                //
                // Start of Frame headers:
                //
                //    FF C0 - SOF0  - Baseline
                //    FF C1 - SOF1  - Extended sequential
                //    FF C2 - SOF2  - Progressive
                //    FF C3 - SOF3  - Loseless
                //
                //    FF C5 - SOF5  - Differential sequential
                //    FF C6 - SOF6  - Differential progressive
                //    FF C7 - SOF7  - Differential lossless
                //    FF C9 - SOF9  - Extended sequential, arithmetic coding
                //
                //    FF CA - SOF10 - Progressive, arithmetic coding
                //    FF CB - SOF11 - Lossless, arithmetic coding
                //
                //    FF CD - SOF13 - Differential sequential, arithmetic coding
                //    FF CE - SOF14 - Differential progressive, arithmetic coding
                //    FF CF - SOF15 - Differential lossless, arithmetic coding
                //
                // Each of these SOF data markers have the same data structure:
                // struct {
                //   UInt16 header; // e.g. FFC0
                //   UInt16 frameLength;
                //   UInt8 samplePrecision;
                //   UInt16 imageHeight;
                //   UInt16 imageWidth;
                //   ... // we only care about this part
                // }
                
                UInt8 sample = 0;
                [data getBytes:&sample range:NSMakeRange(offset, 1)];
                offset++;
                
                // Technically we should check if this has EXIF data here (looking for FFE1 marker)…
                // Maybe TODO later
                if (_FIValueBetween(sample, 0xE0, 0xEF)) {
                    state = _FIJPEGStateSkipFrame;
                    
                } else if (_FIValueBetween(sample, 0xC0, 0xC3) ||
                           _FIValueBetween(sample, 0xC5, 0xC7) ||
                           _FIValueBetween(sample, 0xC9, 0xCB) ||
                           _FIValueBetween(sample, 0xCD, 0xCF)) {
                    state = _FIJPEGStateFoundSOF;
                    
                } else if (sample == 0xFF) {
                    state = _FIJPEGStateDetermineFrameType;
                    
                } else if (sample == 0xD9) {
                    // We made it to the end of the file somehow without finding the size? Likely a corrupt file
                    state = _FIJPEGStateFoundEOI;
                    
                } else {
                    // Since we don't handle every header case default to skipping an unknown data marker
                    state = _FIJPEGStateSkipFrame;
                    
                }
                
                break;
            }
                
            case _FIJPEGStateSkipFrame: {
                UInt16 frameLength = 0;
                [data getBytes:&frameLength range:NSMakeRange(offset, 2)];
                frameLength = CFSwapInt16BigToHost(frameLength);
                
                offset += (frameLength - 1);
                state = _FIJPEGStateFindHeader;
                break;
            }
                
            case _FIJPEGStateFoundSOF: {
                offset += 3; // Skip the frame length and sample precision, see above ^
                [data getBytes:&jpeg_size range:NSMakeRange(offset, 4)];
                return CGSizeMake(CFSwapInt16BigToHost(jpeg_size.width), CFSwapInt16BigToHost(jpeg_size.height));
            }
                
            case _FIJPEGStateFoundEOI: {
                return CGSizeZero;
            }
        }
    }
    
    return CGSizeZero;
}

-(void)setFeedModel:(NakedHubFeedModel *)feedModel
{
    _feedModel = feedModel;
    self.likeBtn.isAnimation = NO;
    self.likeBtn.isLike = feedModel.liked;
    self.likeCountLabel.text = @(feedModel.likeNum).stringValue;
    [_headPortraitView sd_setImageWithURL:[NSURL URLWithString:feedModel.user.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _nameLabel.text = feedModel.user.nickname;
    _distanceLabel.text = feedModel.postTime;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Book" size:16.0],NSFontAttributeName, nil];
    
    
    
    
//    _contentLabel.delegate = self;
//    
//    self.contentLabel.linkAttributes =  @{((__bridge NSString *)kCTUnderlineStyleAttributeName):@(NO),((__bridge NSString *)kCTForegroundColorAttributeName):[UIColor colorWithRed:35.0/255.0 green:153.0/255.0 blue:236.0/255.0 alpha:1.0]};
//    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
//    
//    
//    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
//    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
//    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
//    self.contentLabel.activeLinkAttributes = mutableActiveLinkAttributes;

    
    
    [_contentLabel setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:16.0]}];
    
    [_contentLabel setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:35.0/255.0 green:153.0/255.0 blue:236.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:16.0]} hotWord:STTweetLink];
    
    [_contentLabel setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:16.0]} hotWord:STTweetHashtag];
    
    [_contentLabel setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:16.0]} hotWord:STTweetHandle];
    
    
    if (!feedModel.content||feedModel.content.length<=0) {
        _contentLabel.text = @"";
        _contentLabelTopConstraint.constant = 0;
        _contentLabelWidth.constant = 0;
    }
    else
    {
        _contentLabelTopConstraint.constant = 20;
        CGSize size = [feedModel.content boundingRectWithSize:CGSizeMake(kScreenWidth-40,CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _contentLabelWidth.constant = size.height;
        _contentLabel.text = feedModel.content;
    }
    
    [self.contentLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        
        switch (hotWord) {
            case STTweetLink:
            {
                if (_ActionClikeLinkBlock) {
                    _ActionClikeLinkBlock([NSURL URLWithString:string]);
                }
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    if (!feedModel.pictureAccessPath) {
        _feedImageView.image = nil;
        _feedImageViewTopConstraint.constant = 0;
        _feedImageHeightConstraint.constant = 0;
    }
    else
    {
         _feedImageViewTopConstraint.constant = 20;
        NSString *imageUrl = [NSString stringWithFormat:@"%@?spec=@25p_1o",feedModel.pictureAccessPath];
        [_feedImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"feedImage"]];
        _feedImageHeightConstraint.constant = 160;
    }
    [_commentsBtn setImage:feedModel.commented?[UIImage imageNamed:@"Comment"]:[UIImage imageNamed:@"CommentOff"] forState:UIControlStateNormal];
    _commentsLabel.text = @(feedModel.commentNum).stringValue;
    _hubNameLabel.text = feedModel.user.company.name;
    _adressLabel.text = feedModel.user.hub.name;
}


- (void) ClikeHeadPortraitView:(UITapGestureRecognizer*)sender
{
    if (_clikeUserAvatarImageViewActionBlock) {
        _clikeUserAvatarImageViewActionBlock((UIImageView*)sender.view);
    }
}

-(void) gotoUserDetailsVC:(NakedUserModel*)user andVC:(UIViewController*)vc
{
    [mixPanel track:@"Feed_userDetail" properties:logInDic];
    
    ((NakedPerSonalDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:vc]).userModel = user;
}


- (void) viewBigImage:(UITapGestureRecognizer*)sender{
    if (_clikeImageViewActionBlock) {
        _clikeImageViewActionBlock((UIImageView*)sender.view);
    }
}

#pragma mark - feed图片操作
-(void)showHostImageView:(UIImageView*)imageV andVC:(UIViewController*)vc
{
    [mixPanel track:@"Feed_pictureDetail" properties:logInDic];
    
    
//    UIImage *image = imageV.image;
//    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image.CGImage];
//    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
//    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
////    ZXDecodeHints *hints = [ZXDecodeHints hints];
//    
//    NSError *error = nil;
//    ZXQRCodeMultiReader * reader2 = [[ZXQRCodeMultiReader alloc]init];
//    NSArray *rs = [reader2 decodeMultiple:bitmap error:&error];
//    // 或者  NSArray *rs =[reader2 decodeMultiple:bitmap hints:hints error:&error];
//    NSLog(@" err = %@",error);
//    if (error) {
//        self.QRCodeResul = nil;
//    }
//    for (ZXResult *resul in rs) {
//        self.QRCodeResul = resul.text;
//    }
    // ZXing 只识别单个二维码
    UIImage *image = imageV.image;
    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image.CGImage];
    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
    
    NSError *error;
    
    id<ZXReader> reader;
    if (NSClassFromString(@"ZXMultiFormatReader")) {
        reader = [NSClassFromString(@"ZXMultiFormatReader") performSelector:@selector(reader)];
    }
    ZXDecodeHints *_hints = [ZXDecodeHints hints];
    ZXResult *result = [reader decode:bitmap hints:_hints error:&error];
    if (result == nil) {
        NSLog(@"无QRCode");
        self.QRCodeResul = nil;
//        return;
    }
    else
    {
        self.QRCodeResul = result.text;
    }
    NSLog(@"QRCode = %d，%@",result.barcodeFormat,result.text);
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//#if TRY_AN_ANIMATED_GIF == 1
    imageInfo.imageURL = [NSURL URLWithString:_feedModel.pictureAccessPath];
//#else
//    imageInfo.image =  .image;
//#endif
    imageInfo.referenceRect = imageV.frame;
    imageInfo.referenceView = imageV.superview;
    imageInfo.referenceContentMode = imageV.contentMode;
    imageInfo.referenceCornerRadius = imageV.layer.cornerRadius;
    
    // Setup view controller
    _imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [_imageViewer showFromViewController:vc transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    [_imageViewer.view addGestureRecognizer:longTap];
    
//    UIImageView *fromView = nil;
//    NSMutableArray *items = [NSMutableArray new];
//        UIImageView *imgView = imageV;
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = imgView;
//        item.largeImageURL = [NSURL URLWithString:_feedModel.pictureAccessPath];
//        [items addObject:item];
//        fromView = imgView;    
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromImageView:fromView toContainer:[[UIApplication sharedApplication].delegate window] animated:YES completion:nil];
}

-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[GDLocalizableClass getStringForKey:@"Save Image"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Save To Album"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(_imageViewer.image, self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        
        UIAlertAction *QRCodeAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Recognize QR code"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_imageViewer dismiss:YES];
            if (_RecognizeQRCodeCallBack) {
                _RecognizeQRCodeCallBack();
            }
        }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:saveAction];
        if (self.QRCodeResul) {
           [alertController addAction:QRCodeAction];
        }
        
        [alertController addAction:cancelAction];
        [_imageViewer presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

// 写到文件的完成时执行
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != nil) {
        [_imageViewer showHint:[GDLocalizableClass getStringForKey:@"Failed"]];
//        NSLog(@"%@", error.description);
    } else {
        [_imageViewer showHint:[GDLocalizableClass getStringForKey:@"Done"]];
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (_ActionClikeLinkBlock) {
        _ActionClikeLinkBlock(url);
    }
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didLongPressLinkWithURL:(__unused NSURL *)url atPoint:(__unused CGPoint)point {
//    [[[UIAlertView alloc] initWithTitle:@"URL Long Pressed"
//                                message:@"You long-pressed a URL. Well done!"
//                               delegate:nil
//                      cancelButtonTitle:@"Woohoo!"
//                      otherButtonTitles:nil] show];
}


-(void)ClikeWithLink:(NSURL*)string
                   andController:(UIViewController*)vc
{
//    NSString *encodedString=[string.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *weburl = [NSURL URLWithString:encodedString];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:string];
//    webViewController.t
    webViewController.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:webViewController animated:YES];
}

-(void)commentClikeWithFeedModel:(NakedHubFeedModel*)model
                          andController:(UIViewController*)vc
{
    NakedHubFeedDetailsViewController* FeedDetailsVC = (NakedHubFeedDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController" andParent:vc];
    FeedDetailsVC.feedModel = model;
    @weakify(FeedDetailsVC)
    [FeedDetailsVC setLikeCallBack:^(NakedHubFeedModel *feedModel){
        @strongify(FeedDetailsVC)
        FeedDetailsVC.feedModel = feedModel;
        [((NakedHubFeedListViewController*)vc).tableView reloadData];
    }];
    
    [FeedDetailsVC setCommentsCallBack:^(NakedHubFeedModel *feedModel){
        @strongify(FeedDetailsVC)
        FeedDetailsVC.feedModel = feedModel;
        [((NakedHubFeedListViewController*)vc).tableView reloadData];
    }];
    [mixPanel track:@"Feed_comment" properties:logInDic];
}

-(void)likeClikeWithFeedModel:(NakedHubFeedModel*)model
                       andController:(UIViewController*)vc
                          and:(void(^)(NakedHubFeedModel*model))block
{
    model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
    self.likeCountLabel.text = @(model.likeNum).stringValue;
    self.likeBtn.isAnimation = YES;
    model.liked = !model.liked;
    self.likeBtn.selected = !self.likeBtn.selected;
    [mixPanel track:@"Feed_like" properties:logInDic];
    @weakify(self)
    [HttpRequest postWithURLSession:feed_like_new andViewContoller:vc andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"feedId":@(model.feedId)}] andBlock:^(id response, NSError *error) {
         @strongify(self)
        if (error) {
            [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            self.likeBtn.isAnimation = NO;
            self.likeBtn.selected = !self.likeBtn.selected;
            model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
            model.liked = !model.liked;
            self.likeCountLabel.text = @(model.likeNum).stringValue;
            if (block) {
                block(model);
            }
        }
        else
        {
            if ([response[@"code"]integerValue]!=200){
                [Utility showErrorWithVC:vc andMessage:response[@"msg"]];
                self.likeBtn.isAnimation = NO;
                self.likeBtn.selected = !self.likeBtn.selected;
                model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
                model.liked = !model.liked;
                self.likeCountLabel.text = @(model.likeNum).stringValue;
                if (block) {
                    block(model);
                }
            }
            else
            {
                model.likers = [[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"] error:nil]mutableCopy];
                if (block) {
                    block(model);
                }
            }
        }
    }];
    if (block) {
        block(model);
    }
    /*[HttpRequest postWithURLSession:feed_like andViewContoller:nil andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"feedId":@(model.feedId)}] andBlock:^(id response, NSError *error) {
     
       NakedHubFeedModel *tempModel = [MTLJSONAdapter modelOfClass:[NakedHubFeedModel class] fromJSONDictionary:response[@"result"] error:nil];
        model.likeNum = tempModel.likeNum;
        model.liked = tempModel.liked;
        self.likeCountLabel.text = @(tempModel.likeNum).stringValue;
        self.likeBtn.isAnimation = NO;
        self.likeBtn.selected = tempModel.liked;
        if ([vc isKindOfClass:[NakedHubFeedDetailsViewController class]]) {
            if (((NakedHubFeedDetailsViewController*)vc).likeCallBack) {
                ((NakedHubFeedDetailsViewController*)vc).likeCallBack();
            }
        }
    }];*/
}

-(void)pullList:(UIViewController*)vc andModel:(NakedHubFeedModel*)model
{
    if ([vc isKindOfClass:[NakedHubFeedDetailsViewController class]]) {
        ((NakedHubFeedDetailsViewController*)vc).feedModel = model;
    }
}

-(void)ForWardClikeWithFeedModel:(NakedHubFeedModel*)model
                          andController:(UIViewController*)vc
{
    [HttpRequest postWithURLSession:user_report andViewContoller:vc andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"reportType":@"FEED",@"refId":@(model.feedId)}] andBlock:^(id response, NSError *error) {
        if (!error) {
            [Utility showSuccessWithVC:vc
                            andMessage:[GDLocalizableClass getStringForKey:@"Got it! Thanks!"]];
        }
        else
        {
            [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
}



- (IBAction)favorite:(SYFavoriteButton *)sender {
//     sender.selected = !sender.selected;
    if(_buttonActionBlock)
    {
        _buttonActionBlock(sender);
    }
}
- (IBAction)comment:(UIButton *)sender {
    if(_buttonActionBlock)
    {
        _buttonActionBlock(sender);
    }
}

- (IBAction)more:(UIButton *)sender {
    if(_buttonActionBlock)
    {
        _buttonActionBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

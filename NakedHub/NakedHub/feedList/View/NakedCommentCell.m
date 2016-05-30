//
//  NakedCommentCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedCommentCell.h"
#import "HttpRequest.h"
#import "SVWebViewController.h"
#import "NakedPerSonalDetailsViewController.h"



@implementation NakedCommentCell


-(void)setCommentsModel:(NakedHubCommentsModel *)commentsModel
{
    _commentsModel = commentsModel;
    [_headPortraitView sd_setImageWithURL:[NSURL URLWithString:commentsModel.user.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _nameLabel.text = commentsModel.user.nickname;
    _distanceLabel.text = commentsModel.postTime;
//    NSString *tempHubName;
//    if (commentsModel.user.company.name) {
//        tempHubName = commentsModel.user.company.name;
//    }
//    if (commentsModel.user.hub.name) {
//        tempHubName = [tempHubName stringByAppendingString:[NSString stringWithFormat:@", %@",commentsModel.user.hub.name]];
//    }
    
    
    _adressLabel.text = commentsModel.user.hub.name;
    _nakedHubNameLabel.text = commentsModel.user.company.name;
    _contentLabel.delegate = self;
    
    
    self.contentLabel.linkAttributes =  @{((__bridge NSString *)kCTUnderlineStyleAttributeName):@(NO),((__bridge NSString *)kCTForegroundColorAttributeName):[UIColor colorWithRed:35.0/255.0 green:153.0/255.0 blue:236.0/255.0 alpha:1.0]};
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    _contentLabel.text = commentsModel.content;
    
    
    self.favoriteBtn.isAnimation = NO;
    self.favoriteBtn.isLike = commentsModel.liked;
    [_likeBtn setTitle:[NSString stringWithFormat:@"%li",(long)commentsModel.likeNum] forState:UIControlStateNormal];
//    [_likeBtn setTitleColor:commentsModel.liked?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0] forState:UIControlStateNormal];
}


-(void)ClikeWithLink:(NSURL*)string
       andController:(UIViewController*)vc
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:string];

    webViewController.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (_ActionClikeLinkBlock) {
        _ActionClikeLinkBlock(url);
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:self.headPortraitView CornerWithRadius:self.headPortraitView.frame.size.height/2];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapHeadPortraitView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClikeHeadPortraitView:)];
    self.headPortraitView.userInteractionEnabled = YES;
    [self.headPortraitView addGestureRecognizer:tapHeadPortraitView];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)likeClikeWithFeedModel:(NakedHubCommentsModel*)model
                andController:(UIViewController*)vc
                          and:(void(^)(NakedHubCommentsModel*model))block
{
    model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%li",(long)model.likeNum] forState:UIControlStateNormal];
    self.favoriteBtn.isAnimation = YES;
    model.liked = !model.liked;
    self.favoriteBtn.selected = !self.favoriteBtn.selected;
    [mixPanel track:@"Feed_like" properties:logInDic];
    @weakify(self)
    [HttpRequest postWithURLSession:feed_comment_like andViewContoller:vc andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"commentId":@(model.commentsId)}] andBlock:^(id response, NSError *error) {
        @strongify(self)
        if (error) {
            [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            self.favoriteBtn.isAnimation = NO;
            self.favoriteBtn.selected = !self.favoriteBtn.selected;
            model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
            model.liked = !model.liked;
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%li",(long)model.likeNum] forState:UIControlStateNormal];
            if (block) {
                block(model);
            }
        }
        else
        {
            if ([response[@"code"]integerValue]!=200){
                [Utility showErrorWithVC:vc andMessage:response[@"msg"]];
                [Utility showErrorWithVC:vc andMessage:error.description];
                self.favoriteBtn.isAnimation = NO;
                self.favoriteBtn.selected = !self.favoriteBtn.selected;
                model.likeNum = model.liked?(model.likeNum-1):(model.likeNum+1);
                model.liked = !model.liked;
                [self.likeBtn setTitle:[NSString stringWithFormat:@"%li",(long)model.likeNum] forState:UIControlStateNormal];
                if (block) {
                    block(model);
                }
            }
        }
    }];
    if (block) {
        block(model);
    }
}


-(void)likeCommentWithVC:(UIViewController*)vc andComments:(NakedHubCommentsModel*)commentsModel
{
    [mixPanel track:@"Feed_commentLike" properties:logInDic];
    
    @weakify(self)
    [HttpRequest postWithURLSession:feed_comment_like andViewContoller:vc andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"commentId":@(commentsModel.commentsId)}] andBlock:^(id response, NSError *error) {
        @strongify(self)
        if (!error) {
            NakedHubCommentsModel *CommentsModel = [MTLJSONAdapter modelOfClass:[NakedHubCommentsModel class] fromJSONDictionary:response[@"result"] error:nil];
            commentsModel.liked = CommentsModel.liked;
            commentsModel.likeNum = CommentsModel.likeNum;
            self.favoriteBtn.isAnimation = YES;
            self.favoriteBtn.isLike = commentsModel.liked;
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%li",(long)commentsModel.likeNum] forState:UIControlStateNormal];
        }
        else
        {
            [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
}

- (IBAction)likeAction:(UIButton *)sender {
    if (_likeClikeCallBack) {
        _likeClikeCallBack();
    }
}
@end

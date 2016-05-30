//
//  NakedHubPostFeedViewController.m
//  NakedHub
//
//  Created by 朱明 on 16/3/11.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedHubPostFeedViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HttpRequest.h"
#import "Utility.h"
#import "UIActionSheet+BlocksKit.h"
#import "SZTextView.h"

@interface NakedHubPostFeedViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (nonatomic,assign) CGFloat oldHeight;

@property (weak, nonatomic) IBOutlet SZTextView *postContentView;
@property (weak, nonatomic) IBOutlet UIImageView *feedImageView;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic,assign) CGSize size;

- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)post:(UIButton *)sender;
- (IBAction)deleteImage:(UIButton *)sender;


@end

@implementation NakedHubPostFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utility configSubView:_postBtn CornerWithRadius:5.0];
    
    BOOL isPhoto = _isPhoto();
    if (isPhoto) {
        [_postContentView resignFirstResponder];
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
        [actionsheet showInView:self.view];
        
    } else {
        [self.postContentView becomeFirstResponder];
    }
    
    self.title = [GDLocalizableClass getStringForKey:@"New Post"];
    
    [self.postContentView setPlaceholder:[GDLocalizableClass getStringForKey:@"What would you like to say to the community?"]];

    
    _oldHeight = self.textViewHeight.constant;
    _size = self.postContentView.contentSize;
    
    @weakify(self)
    [[RACSignal combineLatest:@[[RACSignal merge:@[_postContentView.rac_textSignal,RACObserve(_postContentView, text)]],RACObserve(self.feedImageView, image)] reduce:^(NSString *content, UIImage *image){
        
        @strongify(self)
        self.delBtn.hidden = image == nil;
        CGFloat height = 80;
        if (self.postContentView.text.length>0){
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Book" size:18.0],NSFontAttributeName, nil];
            CGSize size = [self.postContentView.text boundingRectWithSize:CGSizeMake(self.postContentView.frame.size.width,150) options: NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            height = size.height;
            self.postBtn.hidden = NO;
        }
        else
        {
            self.postContentView.contentSize = _size;
            
            if (_feedImageView.image == nil) {
                self.postBtn.hidden = YES;
            }
            else
            self.postBtn.hidden = NO;
        }
        self.textViewHeight.constant = height<80?80:height;
        return @(self.postContentView.text.length>0 || image != nil);
    }]subscribeNext:^(id x) {
        @strongify(self)
    
        [self.postBtn setBackgroundColor:[x boolValue]?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
        self.postBtn.enabled = [x boolValue];
        [self.postBtn setTitle:[GDLocalizableClass getStringForKey:@"POST"] forState:UIControlStateNormal];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)postFeed{
    
    if ([Utility isEmpty:_postContentView.text]&&self.feedImageView.image==nil) {
        self.postContentView.text = nil;
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"You can't send meesage without any characters."]];
        return;
    }
    
    @weakify(self)
    [HttpRequest upLoadWithUrl:feed_post andViewContoller:self andHudMsg:@"" andUploadImageName:@"file" andImages:self.feedImageView.image?[NSMutableArray arrayWithArray:@[self.feedImageView.image]]:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"content":_postContentView.text}] andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            if (_pull) {
                _pull();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
}

-(void)showImagePickerControllerWithPickerType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    [picker setSourceType:type];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    _feedImageView.image = [Utility imageByScalingToMaxSize:portraitImg];
//    _feedImageView.image = portraitImg;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.postBtn.hidden = NO;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.toolsBottomConstraint.constant = CGRectGetHeight(keyboardRect);
        } else {
            self.toolsBottomConstraint.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showImagePickerControllerWithPickerType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == 1) {
        [self showImagePickerControllerWithPickerType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (IBAction)deleteImage:(UIButton *)sender {
    _feedImageView.image = nil;
    sender.hidden = YES;
    
    if (_postContentView.text.length > 0) {
        self.postBtn.hidden = NO;
    }
    else
    self.postBtn.hidden = YES;
}
- (void)close {
    [self.postContentView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    [mixPanel track:@"Feed_selectPicture" properties:logInDic];
    [_postContentView resignFirstResponder];
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
    [actionsheet showInView:self.view];
}

- (IBAction)post:(UIButton *)sender {
    [self postFeed];
    [mixPanel track:@"Feed_post" properties:logInDic];
}

- (IBAction)BackBarItemAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

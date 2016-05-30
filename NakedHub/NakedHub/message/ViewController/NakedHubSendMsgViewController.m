//
//  NakedHubSendMsgViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubSendMsgViewController.h"
#import "JSTokenField.h"
#import "NakedUserModel.h"
#import "NakedHubUserCell.h"
#import "MBAutoGrowingTextView.h"
#import "UIViewController+KeyboardAnimation.h"
#import "UIViewController+DismissKeyboard.h"
#import "NakedHubGroupModel.h"
#import "EMMessage.h"
#import "ChatSendHelper.h"
#import "TITokenField.h"
#import "NakedHubMemberCell.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
#import "EMChatManagerDefs.h"

@interface NakedHubSendMsgViewController ()<TITokenFieldDelegate, UITextViewDelegate,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,IChatManagerDelegate,EMCDDeviceManagerDelegate>
{
    CGFloat _keyboardHeight;
    NSURLSessionDataTask *task;
}
@property (weak, nonatomic) IBOutlet TITokenFieldView *TokenField;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tokenFieldHeightConstraint;
@property (nonatomic, strong) NSMutableArray *toRecipients;

@property (nonatomic, strong) NSMutableArray *toUsers;

@property (nonatomic, assign) NSInteger delCount;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *bgTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intPutToolsViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (nonatomic,strong) UIImage *sendImage;
@property (weak, nonatomic) IBOutlet UIButton *selectImageBtn;

@end

@implementation NakedHubSendMsgViewController
- (IBAction)sendImage:(UIButton *)sender {
    if (_toRecipients.count<=0) {
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Please select the contact"]];
    }
    else
    {
        [_textView resignFirstResponder];
         UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
        [actionsheet showInView:self.view];
    }
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
    _sendImage = [Utility imageByScalingToMaxSize:portraitImg];
     [self createGroupChatWithType:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)postMsg:(UIButton *)sender {
    [mixPanel track:@"Message_newMessage_post" properties:logInDic];
    [self createGroupChatWithType:NO];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createGroupChatWithType:(BOOL)isImg
{
    
    if ([Utility isEmpty:_textView.text]) {
        self.textView.text = nil;
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"You can't send meesage without any characters."]];
        return;
    }
    if (_toRecipients.count>1) {
        NSString *userIds = @"";
        for (NakedUserModel *user in _toRecipients) {
            if (userIds.length<=0) {
                userIds = @(user.userId).stringValue;
            }
            else
            {
                userIds = [userIds stringByAppendingString:[NSString stringWithFormat:@",%@",@(user.userId).stringValue]];
            }
        }
        [HttpRequest postWithURLSession:chat_group_add andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"memberId":userIds}] andBlock:^(id response, NSError *error) {
            if (!error) {
                NakedHubGroupModel *groupModel = [MTLJSONAdapter modelOfClass:[NakedHubGroupModel class] fromJSONDictionary:response[@"result"] error:nil];
                if (isImg) {
                    [self sendImageMessage:self.sendImage andMsgType:eMessageTypeGroupChat andGroupId:groupModel.huanxinGroupId];
                }
                else
                {
                    [self sendTextMessage:self.textView.text andMsgType:eMessageTypeGroupChat andGroupId:groupModel.huanxinGroupId];
                }
                if (_sendMsgSuccessCallBack) {
                    [self.navigationController popViewControllerAnimated:NO];
                    _sendMsgSuccessCallBack(groupModel);
                    
                }
            }
            else{
                [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            }
            
        }];
    }
    else
    {
        NakedUserModel *user = _toRecipients[0];
        if (isImg) {
            [self sendImageMessage:self.sendImage andMsgType:eMessageTypeChat andGroupId:@(user.userId).stringValue];
        }
        else
        {
            [self sendTextMessage:self.textView.text andMsgType:eMessageTypeChat andGroupId:@(user.userId).stringValue];
        }
        if (_sendMsgSuccessCallBack) {
            [self.navigationController popViewControllerAnimated:NO];
            _sendMsgSuccessCallBack( _toRecipients[0]);
        }
    }
}
#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage andMsgType:(EMMessageType)type andGroupId:(NSString*)HXGId
{

    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                toUsername:HXGId
                                                messageType:type
                                                     requireEncryption:NO
                                                                   ext:@{kUserName:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName],kUserAvatarUrl:[[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl],kUserIdName:[[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName] stringValue]}];
    NSLog(@"Message = %@",tempMessage.messageId);
}

-(void)sendImageMessage:(UIImage *)image andMsgType:(EMMessageType)type andGroupId:(NSString*)HXGId
{
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:HXGId
                                                           messageType:type
                                                     requireEncryption:NO
                                                                   ext:@{kUserName:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName],kUserAvatarUrl:[[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl],kUserIdName:[[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName] stringValue]}];
    
    
    NSLog(@"Message = %@",tempMessage.messageId);
}

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [HttpRequest postWithURLSession:chat_saveChatMessage andViewContoller:nil andAttributes:[@{@"content":_textView.text,@"messageType":@"TEXT",@"chatType":message.messageType == eMessageTypeChat ?@"USER2USER":@"USER2GROUP",@"refId":message.conversationChatter,@"easemobMessageId":message.messageId}mutableCopy] andBlock:^(id response, NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
#warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    [[EaseMob sharedInstance].callManager removeDelegate:self];
//    // 注册为Call的Delegate
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = [GDLocalizableClass getStringForKey:@"New Message"];
    [self.bgTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Type your message..."]];
    [self.postBtn setTitle:[GDLocalizableClass getStringForKey:@"Send"] forState:UIControlStateNormal];
    _delCount = 0;
    [Utility configSubView:_postBtn CornerWithRadius:5.0];
    [self.TokenField.tokenField setDelegate:self];
    [self.TokenField setShouldSearchInBackground:NO];
    [_TokenField.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
    [self.TokenField.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
    [self.TokenField.tokenField setPromptText:[GDLocalizableClass getStringForKey:@"To:"]];
    [self.TokenField.tokenField setPlaceholder:[GDLocalizableClass getStringForKey:@"Type a name"]];

    [self.TokenField.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self.TokenField.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    // You can call this on either the view on the field.
    // They both do the same thing.
    [self.TokenField becomeFirstResponder];
    @weakify(self)
    [[RACSignal merge:@[RACObserve(_textView, text),_textView.rac_textSignal]] subscribeNext:^(NSString *text) {
        @strongify(self)
        
        self.bgTextF.text = text.length>0?@" ":@"";
        self.textViewHeightConstraint.constant = self.intPutToolsViewHeight.constant+20;
        self.postBtn.hidden = !(self.textView.text.length>0&&self.toRecipients.count>0);
    }];
    
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
            if (self.toRecipients.count>0) {
                self.bottomConstraint.constant = CGRectGetHeight(keyboardRect);
            }
            else
            {
                self.bottomConstraint.constant = CGRectGetHeight(keyboardRect)-54;
            }
        } else {
            self.bottomConstraint.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark JSTokenFieldDelegate
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    [self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = 0;
    [self resizeViews];
}

- (void)resizeViews {
    int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
    [_TokenField setFrame:((CGRect){_TokenField.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - _keyboardHeight}})];
//    [_messageView setFrame:_tokenFieldView.contentView.bounds];
}


- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
    // There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
    [tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
    [self textViewDidChange:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat oldHeight = _TokenField.frame.size.height - _TokenField.tokenField.frame.size.height;
    CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
    CGRect newTextFrame = textView.frame;
    newTextFrame.size = textView.contentSize;
    newTextFrame.size.height = newHeight;
    CGRect newFrame = _TokenField.contentView.frame;
    newFrame.size.height = newHeight;
    if (newHeight < oldHeight){
        newTextFrame.size.height = oldHeight;
        newFrame.size.height = oldHeight;
    }
    [_TokenField.contentView setFrame:newFrame];
    [textView setFrame:newTextFrame];
    [_TokenField updateContentSize];
}


#pragma mark - Custom Search

- (void)tokenField:(TITokenField *)tokenField didAddToken:(TIToken *)token
{
    _toRecipients = [NSMutableArray arrayWithArray:tokenField.tokenObjects];
    [UIView animateWithDuration:0.5 animations:^{
        self.postBtn.hidden = !(self.textView.text.length>0&&self.toRecipients.count>0);
        self.bottomConstraint.constant  = _toRecipients.count>0?_keyboardHeight:(_keyboardHeight-54);
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
    }];
    
}

- (void)tokenField:(TITokenField *)tokenField didRemoveToken:(TIToken *)token
{
    _toRecipients = [NSMutableArray arrayWithArray:tokenField.tokenObjects];
    [UIView animateWithDuration:0.5 animations:^{
        self.postBtn.hidden = !(self.textView.text.length>0&&self.toRecipients.count>0);
        self.bottomConstraint.constant  = _toRecipients.count>0?_keyboardHeight:(_keyboardHeight-54);
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
    }];
}
- (BOOL)tokenField:(TITokenField *)field shouldUseCustomSearchForSearchString:(NSString *)searchString
{
    return YES;
}
- (NSString *)tokenField:(TITokenField *)tokenField displayStringForRepresentedObject:(id)object
{
    return ((NakedUserModel*)object).nickname;
}


- (void)tokenField:(TITokenField *)field performCustomSearchForSearchString:(NSString *)searchString withCompletionHandler:(void (^)(NSArray *))completionHandler
{
    //新建一个队列
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //记时
//    NSDate *startTime = [NSDate date];
    
    //加入队列
//    dispatch_async(concurrentQueue, ^{
        //1.先去网上读取
//        dispatch_sync(concurrentQueue, ^{
    if (task) {
        [task cancel];
    }
    @weakify(self)
    task = [HttpRequest getWithUrl:user_search andViewContoller:self andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"keyword":searchString}] andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            NSError *error1 = nil;
            self.dataList = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"] error:&error1]];
            NSMutableArray *userIds = [NSMutableArray arrayWithObject:[[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName] stringValue]];
            for (NakedUserModel *user in self.toRecipients) {
                [userIds addObject:@(user.userId).stringValue];
            }
            [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([userIds containsObject:@(((NakedUserModel*)obj).userId).stringValue])
                {
                    [self.dataList removeObjectAtIndex:idx];
                }
            }];
            completionHandler(self.dataList);
        }
    
       
    }];
    
    
    
           /* [HttpRequest getWithUrl:user_search andViewContoller:nil andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"keyword":searchString}] andBlock:^(id response, NSError *error) {
                @strongify(self)
                NSError *error1 = nil;
                self.dataList = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"] error:&error1]];
                NSMutableArray *userIds = [NSMutableArray arrayWithObject:[[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName] stringValue]];
                for (NakedUserModel *user in self.toRecipients) {
                    [userIds addObject:@(user.userId).stringValue];
                }
                [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([userIds containsObject:@(((NakedUserModel*)obj).userId).stringValue])
                    {
                        [self.dataList removeObjectAtIndex:idx];
                    }
                }];
               completionHandler(self.dataList);
            }];*/
//        });
        //2.在主线程展示到界面里
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//        });
//    });
    
}
#pragma mark - Table view data source

- (UITableViewCell *)tokenField:(TITokenField *)tokenField resultsTableView:(UITableView *)tableView cellForRepresentedObject:(id)object
{
    NakedHubMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[NakedHubMemberCell alloc]init];
    }
    cell.userModel = object;
    return cell;
}
- (CGFloat)tokenField:(TITokenField *)tokenField resultsTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

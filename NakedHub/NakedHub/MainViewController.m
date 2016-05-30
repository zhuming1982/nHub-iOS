//
//  MainViewController.m
//  SportSocial
//
//  Created by ZhuMing on 15/10/15.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "MainViewController.h"

#import "UIViewController+HUD.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "SettingsViewController.h"
#import "ApplyViewController.h"
#import "CallViewController.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "HttpRequest.h"
#import "NakedHubFeedDetailsViewController.h"
#import "NHReservationsDetailViewController.h"
#import "NakedPerSonalDetailsViewController.h"
#import "Utility.h"
#import "GYSQL.h"


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";



@interface MainViewController ()<UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate,UITabBarControllerDelegate>
{
    ChatListViewController *_chatListVC;
    ContactsViewController *_contactsVC;
    
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainViewController

-(void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
   
    [defaultCenter removeObserver:self
                             name:SkipToPage
                           object:nil];
    [defaultCenter removeObserver:self
                             name:changeLanguageNoti
                           object:nil];
}

-(void)loadNotificationCenter
{
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    
    [self setTabBarItemTitle];
    
    self.tabBar.tintColor = [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
    
//    [self loadNotificationCenter];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:kPostMessage object:nil];
    
    [self registerNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    // Do any additional setup after loading the view.
    _chatListVC = (ChatListViewController*)((UINavigationController*)self.viewControllers[2]).visibleViewController;
    
    [self setupUnreadMessageCount];
//    [self setupUntreatedApplyCount];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(skipToPage:) name:SkipToPage object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTabBarItemTitle) name:changeLanguageNoti object:nil];

    [super viewDidLoad];
    
    // UITabBarControllerDelegate
    self.delegate = self;
    
    [self getNewPushMsg];
    
  }


-(void)didReceiveNotification:(NSNotification*)not
{
    NSLog(@"%@",not.userInfo);
    
    if (not.userInfo[@"NEW_FRIEND"]) {
        ((UINavigationController*)self.viewControllers[2]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",[not.userInfo[@"NEW_FRIEND"] integerValue]];
    }
    
//    if (!((UINavigationController*)self.viewControllers[2]).tabBarItem.badgeValue) {
//        ((UINavigationController*)self.viewControllers[2]).tabBarItem.badgeValue = @"1";
//    }
//    else
//    {
//        NSInteger i = [((UINavigationController*)self.viewControllers[2]).tabBarItem.badgeValue integerValue];
//        ((UINavigationController*)self.viewControllers[2]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",++i];
//    }
    
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (self.viewControllers[2]) {
        if (unreadCount > 0) {
            self.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            self.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    }
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_chatListVC refreshDataSource];
}
// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    //  后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        for (EMMessage *message in offlineMessages) {
            NHChatUserModel *userModel = [[NHChatUserModel alloc]init];
            userModel.UserName = message.ext[kUserName];
            userModel.UserAvatarUrl = message.ext[kUserAvatarUrl];
            userModel.UserId = message.ext[kUserIdName];
            if (![GYSQL saveNewUser:userModel]) {
                [GYSQL UpLoadUser:userModel];
            }
        }
    }); 
}
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        NHChatUserModel *userModel = [[NHChatUserModel alloc]init];
        userModel.UserName = message.ext[kUserName];
        userModel.UserAvatarUrl = message.ext[kUserAvatarUrl];
        userModel.UserId = message.ext[kUserIdName];
        if (![GYSQL saveNewUser:userModel]) {
            [GYSQL UpLoadUser:userModel];
        }
    });
    
    
    
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:[GDLocalizableClass getStringForKey:@"receiveCmd"]];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr =[GDLocalizableClass getStringForKey:@"message.image"] ;
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = [GDLocalizableClass getStringForKey:@"message.location"] ;
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr =[GDLocalizableClass getStringForKey:@"message.voice"];
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = [GDLocalizableClass getStringForKey:@"message.video"];
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = [GDLocalizableClass getStringForKey:@"receiveMessage"];
    }
    
    
    notification.alertAction =[GDLocalizableClass getStringForKey:@"open"];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
//        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
//                                                            message:hintText
//                                                           delegate:self
//                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
//                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
//                                  nil];
//        alertView.tag = 99;
//        [alertView show];
        [_chatListVC isConnect:NO];
    }
}
#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 101;
//        [alertView show];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:[GDLocalizableClass getStringForKey:@"reconnection.ongoing"]];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:[GDLocalizableClass getStringForKey:@"reconnection.fail"]];
        }else{
            [self showHint:[GDLocalizableClass getStringForKey:@"reconnection.success"]];
        }
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    /* "FEED"="动态"; "EXPLORE"="社区"; "MESSAGES"="消息"; "TODAY"="今天"; "MORE"="更多"; */
    if (0 == tabBarController.selectedIndex)
    {
        [mixPanel track:@"FEED" properties:logInDic];
    }
    if (1 == tabBarController.selectedIndex)
    {
        [mixPanel track:@"EXPLORE" properties:logInDic];
    }
    if (2 == tabBarController.selectedIndex)
    {
        [mixPanel track:@"MESSAGES" properties:logInDic];
    }
    if (3 == tabBarController.selectedIndex)
    {
        [mixPanel track:@"TODAY" properties:logInDic];
    }
    if (4 == tabBarController.selectedIndex)
    {
        [mixPanel track:@"MORE" properties:logInDic];
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        @weakify(self);
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            @strongify(self);
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

#pragma mark ---  JPUsh Msg相关

//消息标记为已读
-(void)push_message_mark:(NSInteger)mark
{
    [HttpRequest postWithURLSession:message_pushmessage_mark andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"messageId":@(mark)}]  andBlock:^(id response, NSError *error) {
        
        if (!error) {
            [Utility BadgeNumChanged:NO withBadgeNum:@"1"];
        }
    }];
}

#pragma mark --- BadgeNum
-(void)changeBadgeNum{
    
    NSString  *badgeNum = [[NSUserDefaults standardUserDefaults]objectForKey:BadgeNumKeyForNSUserDefault];
    if ([badgeNum integerValue] > 0) {
        
        [((UINavigationController*)self.viewControllers[3]).tabBarItem setBadgeValue:badgeNum];
        
    }
    else{
        
        [((UINavigationController*)self.viewControllers[3]).tabBarItem setBadgeValue:nil];
    }
}

-(void)skipToPage:(NSNotification *)userInfo
{
    if ([userInfo.object isKindOfClass:[PushMsgModel class]]) {
        PushMsgModel  *pushMsgModel = userInfo.object;
        
    if ([pushMsgModel.pushSign isEqualToString:@"FEED_COMMENT"]||
            [pushMsgModel.pushSign isEqualToString:@"FEED_LIKE"]||
            [pushMsgModel.pushSign isEqualToString:@"FEED_FOLLOWER_POST"]||
            [pushMsgModel.pushSign isEqualToString:@"COMMENT_LIKE"])
        {
            // 跳转到feed详情
            NakedHubFeedDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"FeedList"  andViewController:@"NakedHubFeedDetailsViewController"];
            DetailVC.feedModelId= pushMsgModel.skipModelId;
            
              if (DetailVC.feedModelId) {
                  [DetailVC setHidesBottomBarWhenPushed:YES];
                  [self targetVCIndex:0 targetVC:DetailVC];
               }
        }
        else if ([pushMsgModel.pushSign isEqualToString:@"RESERVATION_CONFIRM"]   ||
                [pushMsgModel.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_UPCOMING"]||
                [pushMsgModel.pushSign isEqualToString:@" RESERVATION_MEETINGROOM_START"]||
                [pushMsgModel.pushSign isEqualToString:@" RESERVATION_WORKSPACE_UPCOMING"]||
                [pushMsgModel.pushSign isEqualToString:@"RESERVATION_WORKSPACE_CONFIRM_START"]||
               [pushMsgModel.pushSign isEqualToString:@" RESERVATION_WORKSPACE_START"]
                 )
        {
            // 跳转到预定详情
            NHReservationsDetailViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationsDetailViewController"];
            
            DetailVC.Reservation_id= pushMsgModel.skipModelId;
              if (DetailVC.Reservation_id)
              {
                [DetailVC setHidesBottomBarWhenPushed:YES];
                 [self targetVCIndex:3 targetVC:DetailVC];
              }
        }
        else if ([pushMsgModel.pushSign isEqualToString:@"USER_FOLLOW"])
        {
            //  跳转到个人信息
            NakedPerSonalDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"PersonalDetails"andViewController:@"NakedPerSonalDetailsViewController"];
            
            NakedUserModel *use_int=[[NakedUserModel alloc]init];
            use_int.userId=pushMsgModel.skipModelId;
            DetailVC.userModel=use_int;
              if (DetailVC.userModel) {
                [DetailVC setHidesBottomBarWhenPushed:YES];
                [self targetVCIndex:4 targetVC:DetailVC];
              }
        }

        // 跳转成功后msg标记为已读
        [self push_message_mark:pushMsgModel.id];
    }
}

-(void)targetVCIndex:(int)index  targetVC:(UIViewController *)targetVC
{
    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabbarVC = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        
        [self setSelectedIndex:index];
        
        id vc = tabbarVC.viewControllers[index];
        
        if (index == 0) {
            targetVC = (NakedHubFeedDetailsViewController *)targetVC;
        }
        else if (index == 3){
            targetVC = (NHReservationsDetailViewController *)targetVC;
        }
        else if(index == 4){
            targetVC = (NakedPerSonalDetailsViewController *)targetVC;
        }
        
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController*)vc) pushViewController:targetVC animated:YES];
        }
        else{
            [((UIViewController*)vc).navigationController pushViewController:targetVC animated:YES];
        }
    }
}

#pragma mark -- changeLanguage

-(void)setTabBarItemTitle
 {
    NSArray  *tabBarItemTitle = @[@"FEED",@"EXPLORE",@"MESSAGES",@"TODAY",@"MORE"];
     NSArray  *nabBarItemTitle = @[@"Explore",@"Inbox",@"Today",@"More"];
     
     NSDictionary  *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:7.5]};
     
     
     NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
     
     [titleBarAttributes setValue:RGBACOLOR(233, 144, 29, 1.0)forKey:NSForegroundColorAttributeName] ;
     
    [[UITabBar appearance]setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
     
     
     self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
     self.tabBar.layer.shadowOffset = CGSizeMake(0,-1.5);
     self.tabBar.layer.shadowOpacity = 0.3;
     self.tabBar.layer.shadowRadius = 2;
     
     [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
     
    for (int i = 0; i < 5; i++) {
        
        UINavigationController  *nav = (UINavigationController *)self.viewControllers[i];
        
        nav.tabBarItem.title = [GDLocalizableClass getStringForKey:tabBarItemTitle[i]] ;
        [nav.tabBarItem setTitleTextAttributes:attrDic forState:UIControlStateNormal];
        
        if (i!=0) {
           nav.navigationBar.topItem.title = [GDLocalizableClass getStringForKey:nabBarItemTitle[i-1]] ;
        }
        else {
             nav.navigationBar.topItem.title = [GDLocalizableClass getStringForKey:tabBarItemTitle[i]] ;
        }
    }
    
     // 切换语言后要重新获取未读消息数   msg模块和today模块
     [self setupUnreadMessageCount];
    
     [self changeBadgeNum];
}

//获取未读消息数
-(void)getNewPushMsg{
    
    [HttpRequest getWithUrl:getPushMsg_count andViewContoller:nil andHudMsg:@"" andAttributes:nil  andBlock:^(id response, NSError *error) {
        if (!error){
            
        NSString  *badgeNum = [NSString stringWithFormat:@"%@",[response[@"result"] objectForKey:@"countUnReadMessage"]];
            
        [Utility BadgeNumChanged:YES withBadgeNum:badgeNum];
        }
    }];
}

@end

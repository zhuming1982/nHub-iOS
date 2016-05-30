/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+EaseMobDebug.h"
#import "Constant.h"
#import "JPUSHService.h"
#import "NSString+MD5.h"
#import "EaseMob.h"
#import "NetWork/NetWorkAPIUrl.h"
#import "PushMsgModel.h"
#import "URLSingleton.h"

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
//            [self didReceiveRemoteNotification:userInfo];
        }
    }
    
    NSString *apnsCertName = nil;
    NSString *apnsKey = nil;
    
    NSString *appKey;
    NSString *channel;
    
    // JPUsh  证书相关设定
    BOOL isProduction = YES;
    
    if ([Utility isTestServer]) {
        apnsCertName = HUAN_XIN_APNS_TEST_CERT_NAME;
        apnsKey = HUAN_XIN_TEST_APPKEY;
        appKey = @"43a8165bb8acaf1f46076792";
        channel = @"JPush";
        isProduction = NO;
        urlClass.urlStr = @"http://webapp.uat.nakedhub.cn/";
    }
    else
    {
        apnsCertName = HUAN_XIN_APNS_CERT_NAME;
        apnsKey = HUAN_XIN_APPKEY;
        isProduction = YES;
        appKey = @"3af6501fe0b69c148c58ca19";
        channel = @"JPush";
        urlClass.urlStr = @"http://webapp.nakedhub.cn/";
    }

    
    _connectionState = eEMConnectionConnected;
    
    [self registerRemoteNotification];

    
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

        [[EaseMob sharedInstance] registerSDKWithAppKey:apnsKey
                                           apnsCertName:apnsCertName
                                            otherConfig:@{kSDKConfigEnableConsoleLogger:@YES}];
    
    
    [self loginChater];
    
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
//     注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiers];
}

-(void)loginChater
{
    BOOL islogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    
    if (!islogin) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]) {
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]] password:[[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]]md5HexDigest]md5HexDigest] completion:^(NSDictionary *loginInfo, EMError *error) {
                
                if (loginInfo && !error) {
                    //设置是否自动登录
                    
                    BOOL islogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
                    
                    if (!islogin) {
                        [[EaseMob sharedInstance].chatManager enableAutoLogin];
                    }
                    // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
                    [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                    //获取数据库中数据
                [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                    
                    //获取群组列表
                    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                    
                    //发送自动登陆状态通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                    
                    //保存最近一次登录用户名
                    
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]] forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
                    [ud synchronize];
                }
                else
                {
                    [self performSelector:@selector(loginChater) withObject:nil afterDelay:3.0];
                }
                
            } onQueue:nil];
            
        }
    }
    
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif{
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
   
     if ([[NSUserDefaults standardUserDefaults]objectForKey:tokenName]){
        [self getNewPushMsg];
     }
}


- (void)appWillResignActiveNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}


- (void)unObserveAllNotifications {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationDidEnterBackgroundNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillEnterForegroundNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationDidFinishLaunchingNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationDidBecomeActiveNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillResignActiveNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationDidReceiveMemoryWarningNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillTerminateNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationProtectedDataWillBecomeUnavailable
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationProtectedDataDidBecomeAvailable
                           object:nil];
}

-(void)dealloc
{
    [self unObserveAllNotifications];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] ;
  //  14b5cb4f07acdc07afd755ce306863d869835cdf9ad5738c951ba28df3494225
    
        //14b5cb4f07acdc07afd755ce306863d869835cdf9ad5738c951ba28df3494225
//    f8941b873c9be2cf6cfd6070edecd4d998380f4fe900d7b8cc18cfaa54c454b9
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:kDeviceTokenName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
//    application.applicationIconBadgeNumber = 0;

    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }

#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
//    UIAlertView *alertView = nil;
    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.beginAutoLogin", @"Start automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        
        // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
        [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        //获取数据库中的数据
        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    }
    
//    [alertView show];
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
//    UIAlertView *alertView = nil;
    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        //获取群组列表
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
        
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    }
    
//    [alertView show];
}

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
//    if (!message) {
//        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
//    [[ApplyViewController shareController] addNewApply:dic];
//    if (self.mainController) {
//        [self.mainController setupUntreatedApplyCount];
//    }
}

// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"group.beKicked" withComment:@"you have been kicked out from the group of \'%@\'"], tmpStr];
    }
    if (str.length > 0) {
//        TTAlertNoTitle(str);
    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat: [GDLocalizableClass getStringForKey:@"group.beRefusedToJoin" withComment:@"be refused to join the group\'%@\'"], groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[GDLocalizableClass getStringForKey:@"Prompt"]  message:reason delegate:nil cancelButtonTitle:[GDLocalizableClass getStringForKey:@"OK"] otherButtonTitles:nil, nil];
    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"group.applyJoin" withComment:@"%@ apply to join groups\'%@\'"],username, groupname];
    }
    else{
        reason = [NSString stringWithFormat: [GDLocalizableClass getStringForKey:@"group.applyJoinWithName" withComment:@"%@ apply to join groups\'%@\'：%@"], username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"group.sendApplyFail" withComment:@"send application failure:%@\nreason：%@"], reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[GDLocalizableClass getStringForKey:@"Error"]  message:message delegate:nil cancelButtonTitle:[GDLocalizableClass getStringForKey:@"OK"]  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        [[ApplyViewController shareController] addNewApply:dic];
//        if (self.mainController) {
//            [self.mainController setupUntreatedApplyCount];
//        }
    }
}

// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if(error)
    {
        return;
    }
    
//    NSString *groupTag = group.groupSubject;
//    if ([groupTag length] == 0) {
//        groupTag = group.groupId;
//    }
    
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
//        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    _connectionState = connectionState;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        if ([((UITabBarController*)self.window.rootViewController).selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
            [nav popToRootViewControllerAnimated:NO];
            ((UITabBarController*)self.window.rootViewController).selectedIndex = 2;
        }
    }
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (!userInfo[@"pushSign"]) {
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            if ([((UITabBarController*)self.window.rootViewController).selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
                [nav popToRootViewControllerAnimated:NO];
                ((UITabBarController*)self.window.rootViewController).selectedIndex = 2;
            }
        }
    }

 if ([[NSUserDefaults standardUserDefaults]objectForKey:tokenName]){
        
    [JPUSHService handleRemoteNotification:userInfo];
     completionHandler(UIBackgroundFetchResultNewData);
    
//    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    
    NSString  *badgeNum = [[NSUserDefaults standardUserDefaults]objectForKey:BadgeNumKeyForNSUserDefault];
   
//   int newBadgeNum =[badgeNum intValue]+ [aps[@"badge"] intValue];
    
//    [application setApplicationIconBadgeNumber:[aps[@"badge"] intValue]];
    
    int newBadgeNum =[badgeNum intValue]+ 1;
    
    NSString *badgeCount = [NSString stringWithFormat:@"%d",newBadgeNum];

    [Utility BadgeNumChanged:YES withBadgeNum:badgeCount];
    
     NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
     NSInteger unreadCount = 0;
     for (EMConversation *conversation in conversations) {
         unreadCount += conversation.unreadMessagesCount;
     }
     unreadCount = unreadCount + newBadgeNum;
     
     [application setApplicationIconBadgeNumber:unreadCount];
     
   self.pushMsgModel = [MTLJSONAdapter modelOfClass:[PushMsgModel class] fromJSONDictionary:userInfo error:nil];
    
    if(application.applicationState == UIApplicationStateInactive){
        //程序处于后台
        [[NSNotificationCenter defaultCenter] postNotificationName:SkipToPage object:self.pushMsgModel];
    }
  }
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

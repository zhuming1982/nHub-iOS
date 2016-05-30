//
//  AppDelegate.m
//  NakedHub
//
//  Created by 朱明 on 16/3/7.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "AppDelegate+EaseMob.h"
#import "Constant.h"
#import "NetWorkAPIUrl.h"
#import "LocationManager.h"
#import "NakedHubModel.h"

#import "UncaughtExceptionHandler.h"

//#import "GDLocalizableClass.h"

#import "AlipayHeader.h"
#define MIXPANEL_TOKEN @"9c31e39e3d07220227c2198e5a7bc0be"

//微信SDK头文件
#import "WXApi.h"

// Umeng 统计
#import "MobClick.h"

#import "HttpRequest.h"
#import "NHURLCache.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

//@synthesize pushMsgModel;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NSURLCache  * sharedCache  =  [[ NHURLCache  alloc ]  initWithMemoryCapacity: 2  *  1024  *  1024
//                                                                    diskCapacity: 100  *  1024  *  1024
//                                                                        diskPath: nil ];
//    [NHURLCache  setSharedURLCache:sharedCache];
    // Umeng 统计
    [MobClick startWithAppkey:@"571dc97be0f55aacc400015c" reportPolicy:BATCH channelId:nil];
    // 获取 iOS 默认的 UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取App名称，我的App有本地化支持，所以是如下的写法
    NSString *appName = @"nakedHub";
    // 如果不需要本地化的App名称，可以使用下面这句
    // NSString * appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@", appName, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN launchOptions:launchOptions];
   
    
    [GDLocalizableClass initUserLanguage];

    [self setUDIDIfNeeded];
    [LocationManager shared];
    _connectionState = eEMConnectionConnected;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:tokenName])
    {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
        [[UIApplication sharedApplication].delegate window].rootViewController = tabBarVC;
    }
   
    [WXApi  registerApp:@"wx4e3446d7b2b52017"];
//    InstallUncaughtExceptionHandler();
    
    return YES;
}


#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    //    UINavigationController *nav = nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        //        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        //        if (_mainController == nil) {
        //            _mainController = [[MainViewController alloc] init];
        //            [_mainController networkChanged:_connectionState];
        //            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        //        }else{
        //            nav  = _mainController.navigationController;
        //        }
        
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    }else{//登陆失败加载登陆页面控制器
        //        _mainController = nil;
        //        LoginViewController *loginController = [[LoginViewController alloc] init];
        //        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        //        loginController.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
        
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    }
}

- (void)setUDIDIfNeeded {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kUDIDName] != nil) {
        return;
    }
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
        // iOS 6+
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        // before iOS 6, so just generate an identifier and store it
        uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"identiferForVendor"];
        if( !uniqueIdentifier ) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            uniqueIdentifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
            [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"identifierForVendor"];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:kUDIDName];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark - WXApiDelegate


-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@(YES)];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default: {
                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@(NO)];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return YES;
}

#endif
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    application.networkActivityIndicatorVisible=NO;
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
    
    if ([url.host isEqualToString:@"safepay"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 进程进入后台或者杀死调用
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:tokenName]) {
        [application setApplicationIconBadgeNumber:0];
    } else {
        NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        NSString *badge = [[NSUserDefaults standardUserDefaults] objectForKey:BadgeNumKeyForNSUserDefault];
        unreadCount = unreadCount + [badge integerValue];
        [application setApplicationIconBadgeNumber:unreadCount];
    }
//     [application setApplicationIconBadgeNumber:(application.applicationIconBadgeNumber-1)];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

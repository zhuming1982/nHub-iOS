//
//  Utility.m
//  NakedHub
//
//  Created by 朱明 on 16/3/9.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "Utility.h"
#import "Constant.h"
#import "NakedLoginWithPhoneViewController.h"
#import "NakedLoginWithEmailViewController.h"
#import "NakedHubTeamCodeViewController.h"
#import "NSString+MD5.h"
#import "NakedEAIntroViewController.h"
#import "JPUSHService.h"
#import "MBProgressHUD.h"
#import "APIModel.h"
#import "URLSingleton.h"

static MBProgressHUD *HUD;

static UIAlertView *alertView;

@implementation Utility

+ (void)showHUD:(NSString *)msg{
    
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.labelText = msg;
    //HUD.mode=MBProgressHUDModeText;
    [HUD show:YES];
}
+ (void)showHUD:(NSString *)msg andView:(UIView*)view
{
    HUD = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = msg;
    //HUD.mode=MBProgressHUDModeText;
    [HUD show:YES];
}
+ (void)removeHUD:(NSInteger)time{
    
    [HUD hide:YES afterDelay:time];
    //    for (UIView *hud in  [UIApplication sharedApplication].keyWindow.subviews)
    //    {
    //        if ([hud isKindOfClass:[MBProgressHUD class]]) {
    //            [hud removeFromSuperview];
    //        }
    //    }
    [HUD removeFromSuperViewOnHide];
}


+ (void) logOutWithVC:(UIViewController* _Nullable)vc
           andIsCycle:(BOOL)isCycle
{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]];
    
    [JPUSHService setTags:[NSSet setWithObject:userId] alias:@"" callbackSelector:nil object:nil];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error && error.errorCode != EMErrorServerNotLogin && error.errorCode != 401 && error.errorCode != EMErrorNotFound) {
//            if (vc) {
                if (isCycle) {
                    [Utility logOutWithVC:vc andIsCycle:isCycle];
                }
//            }
        }
        else{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isCompany"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:tokenName];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserIdName];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserName];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserAvatarUrl];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hubID"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hubaddress"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hubname"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hubpicture"];
//            [[ApplyViewController shareController] clear];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
//            [Utility replaceView:@"RegisterOrLoginNav"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[UIApplication sharedApplication].delegate window].rootViewController =
            [Utility GetViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedEAIntroViewController"];
//            [NetHelper clearToken];
        }
    } onQueue:nil];
}


+ (void)loginResultAndBlock:(void (^)(id response, EMError *error))block {
    //环信登录
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]];
    NSString *password = [[userId md5HexDigest]md5HexDigest];
    
    [JPUSHService setTags:[NSSet setWithObject:userId] alias:userId callbackSelector:nil object:nil];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userId password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (loginInfo && !error) {
            //设置是否自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
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
            [ud setObject:userId forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
            [ud synchronize];
         
            if (block) {
                block(loginInfo,nil);
            }
        }
        else
        {
            if (block) {
                block(nil,error);
            }
        }
    } onQueue:nil];
}


+(void)configSubView:(UIView*)view CornerWithRadius:(CGFloat)radius
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}

+ (NSString*)getYYYYMMDDWithInt:(long long)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    return [Utility getYYYYMMDD:date];
}
//年 String
+ (NSString*)getYearWithInt:(long long)time {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    return [Utility getYear:date];
}
+ (NSString*)getYear:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    [self currentLanguange:formatter];
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}
//月 String
+ (NSString*)getMonthWithInt:(long long)time {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    return [Utility getMonth:date];
}
+ (NSString*)getMonth:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =[NSString stringWithFormat:@"MMM"];
    [self currentLanguange:formatter];
    
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}
//日 String
+ (NSString*)getDayWithInt:(long long)time {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    return [Utility getDay:date];
}
+ (NSString*)getDay:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    [self currentLanguange:formatter];
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}
//小时分钟
+ (NSString*)getHourMinuteWithInt:(long long)time {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    
    return [Utility getHHMMSS:date];
}
+ (NSString*)getHHMMSS:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [self currentLanguange:formatter];
    
    formatter.dateFormat = @"HH:mm a";
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}
//简写月
+ (NSString*)ZYY:(NSInteger)mInt
{
    NSArray *m = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Nov"];
    return m[mInt-1];
    //    Jan 一月
    //    Feb二月
    //    Mar三月
    //    Apr 四月
    //    May 五月
    //    June 六月
    //    July 七月
    //    Aug八月
    //    Sep 九月
    //    Oct 十月
    //    Nov 十一月 
    //    Nov 十二月
    
}
//全写月
+ (NSString*)C_ZYY:(NSInteger)mInt
{
    NSArray *m = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
    return m[mInt-1];
//    一月January
//    二月February
//    三月March
//    四月April
//    五月May
//    六月June
//    七月July
//    八月August
//    九月September
//    十月October 
//    十一月November 
//    十二月December
    
}

+ (NSString*)getYYYYMMDDHHMM:(NSDate*)aDate {
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [self currentLanguange:formatter];
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}
+ (NSString*)getYYYYMMDDWithIntG:(long long)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@(time).stringValue doubleValue] / 1000];
    return [Utility getYYYYMMDDG:date];
}

+ (NSString*)getYYYYMMDDG:(NSDate*)aDate{
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    [self currentLanguange:formatter];
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}

+ (NSString*)getYYYYMMDD:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [self currentLanguange: formatter];

    NSString *result = [formatter stringFromDate:aDate];
    return result;
}

+ (NSString*)getHHMM:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    [self currentLanguange:formatter];
    NSString *result = [formatter stringFromDate:aDate];
    return result;
}

+ (NSString*)get_book_YYYYMMDD:(NSDate*)aDate {
    
    if (aDate == nil) {
        return @"";
    }
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    BOOL  isShowToday = [gregorian isDateInToday:aDate];
    NSString *result  = nil;
    
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    
    if ([urlStr isEqualToString:@"en"]){
        
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        if (isShowToday == YES) {
            
            formatter.dateFormat = @"MMM dd, yyyy";
            
            NSString *tempStr = [formatter stringFromDate:aDate];
            result = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"Today, %@"],tempStr];
        }
        else{
            formatter.dateFormat = @"MMM dd, yyyy";
            result = [formatter stringFromDate:aDate];
        }
        
        
    }
    else{
        
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        
        if (isShowToday == YES) {
            
            formatter.dateFormat = @"MMM dd yyyy";
            
            NSString *tempStr = [formatter stringFromDate:aDate];
            NSArray  *dateArray = [tempStr componentsSeparatedByString:@" "];
            result = [NSString stringWithFormat:@"今天, %@%@日, %@年",dateArray[0],dateArray[1],dateArray[2]];
        }
        else{
            formatter.dateFormat = @"yyyy MMM dd";
          NSString  *tempStr = [formatter stringFromDate:aDate];
            NSArray   *dateArray = [tempStr componentsSeparatedByString:@" "];
            result = [NSString stringWithFormat:@"%@年%@%@日",dateArray[0],dateArray[1],dateArray[2]];
        }
        
    }
    
    return result;
}

+ (NSString *)get_DDMMYYYY:(NSDate *)aDate
{
    if (aDate == nil) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSString *result  = nil;
    
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];

    if ([urlStr isEqualToString:@"en"])
    {
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        formatter.dateFormat = @"dd MMM yyyy";
        result = [formatter stringFromDate:aDate];
    } else {
        
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        
        formatter.dateFormat = @"yyyy MM dd";
        NSString  *tempStr = [formatter stringFromDate:aDate];
        NSArray   *dateArray = [tempStr componentsSeparatedByString:@" "];
        result = [NSString stringWithFormat:@"%@年 %@月 %@日",dateArray[0],dateArray[1],dateArray[2]];
    }
    
    return result;
}

+(void)currentLanguange:(NSDateFormatter *__nonnull)formatter
{
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    if ([urlStr isEqualToString:@"en"])
    {
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    else
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

+(NSString*)arrTostrWithArr:(NSArray*)arr
{
    NSString *str = @"";
    if (arr.count>0) {
        str = arr[0];
        for (NSString *s in arr) {
            if (![s isEqualToString:arr.firstObject]) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",s]];
            }
        }
    }
    return str;
}

+ (BOOL)isiPhone4 {
    
    BOOL result = NO;
    if (kScreenHeight <= 480) {
        result = YES;
    }
    return result;
}
// 根据nib创建对象
id loadObjectFromNib(NSString *nib, Class cls, id owner) {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil];
    for (id oneObj in nibs) {
        if ([oneObj isKindOfClass:cls]) {
            return oneObj;
        }
    }
    return nil;
}
+ (BOOL)isiPhone5 {
    
    BOOL result = NO;
    if (kScreenHeight > 480 && kScreenHeight <= 568) {
        result = YES;
    }
    return result;
}

+ (BOOL)isiPhone6 {
    
    BOOL result = NO;
    if (kScreenWidth == 375) {
        result = YES;
    }
    return result;
}

+ (BOOL)isiPhone6p {
    
    BOOL result = NO;
    if (kScreenWidth == 414) {
        result = YES;
    }
    return result;
}
+(CGFloat)carouselViewHeight
{
    if([Utility isiPhone4])
    {
        return 204;
    }
    else if([Utility isiPhone5])
    {
        return 286;
    }
    else if([Utility isiPhone6])
    {
        return 374;
    }
    else
    {
        return 424;
    }
}

+(CGFloat)PaymentListViewHeight
{
    if([Utility isiPhone4])
    {
        return 248;
    }
    else if([Utility isiPhone5])
    {
        return 338;
    }
    else if([Utility isiPhone6])
    {
        return 412;
    }
    else
    {
        return 424;
    }
}
+ (nullable id) GetViewControllerWithStoryboard:(NSString*)StoryboardName
                              andViewController:(NSString*)controllerName
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle mainBundle]];
    return [mainStoryboard instantiateViewControllerWithIdentifier:controllerName];
}
+ (UIViewController*) pushViewControllerWithStoryboard:(NSString*)StoryboardName
                                              andViewController:(NSString*)controllerName
                                                      andParent:(UIViewController*)parent {
    UIViewController *viewController = [Utility GetViewControllerWithStoryboard:StoryboardName
                                        andViewController:controllerName];
    [viewController setHidesBottomBarWhenPushed:YES];
    [parent.navigationController pushViewController:viewController
                                           animated:TRUE];
    return viewController;
    
}
+ (BOOL)isLocationValid:(CLLocationCoordinate2D)location {
    return location.latitude > -89 && location.latitude < 89 && location.longitude > -179 && location.longitude < 179;
}

+ (BOOL)isLocationOK:(CLLocationCoordinate2D)location {
//    if (location == nil) {
//        return FALSE;
//    }
    
    CLLocationCoordinate2D location2d;
    location2d.longitude = location.longitude;
    location2d.latitude = location.latitude;
    return [Utility isLocationValid:location2d];
}
+ (void) showSuccessWithVC:(UIViewController*)vc andMessage:(NSString*)msg
{
    if (vc.navigationController.navigationBarHidden){
        [vc.navigationController setNavigationBarHidden:NO];
    }
    [TSMessage showNotificationInViewController:vc.navigationController
                                          title:nil
                                       subtitle:msg
                                          image:nil
                                           type: TSMessageNotificationTypeSuccess
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}

+ (void) showErrorWithVC:(UIViewController*)vc
              andMessage:(NSString*)msg
                andBlock:(void (^)())block
{
    [TSMessage showNotificationInViewController:vc
                                          title:nil
                                       subtitle:msg
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:^{
                                           if (block) {
                                               block();
                                           }
                                       } buttonTitle:nil buttonCallback:^{
                                           
                                       } atPosition:TSMessageNotificationPositionNavBarOverlay canBeDismissedByUser:YES];
}

+ (UIAlertView *) showErrorMessage:(NSString*)msg
{
    if (alertView) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Quit"] otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
    
}

+ (void) showErrorWithVC:(UIViewController*)vc andMessage:(NSString*)msg
{
    if (vc.navigationController.navigationBarHidden){
        [vc.navigationController setNavigationBarHidden:NO];
    }
//    [TSMessage showNotificationInViewController:vc title:nil subtitle:msg type:TSMessageNotificationTypeError];
    
//    [TSMessage showNotificationInViewController:vc.navigationController withTitle:nil withMessage:msg withType:TSMessageNotificationTypeError withDuration:TSMessageNotificationDurationAutomatic withCallback:^{
//        
//    } atPosition:TSMessageNotificationPositionTop];
    
//    if ([vc isKindOfClass:[NakedHubTeamCodeViewController class]]||
//        [vc isKindOfClass:[NakedLoginWithPhoneViewController class]]||
//        [vc isKindOfClass:[NakedLoginWithEmailViewController class]]) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginError" object:nil userInfo:@{@"msg":msg}];
//        return;
//        vc = [Utility GetViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedHubLoginViewController"];
//    }
    [TSMessage showNotificationInViewController:vc.navigationController
                                          title:nil
                                       subtitle:msg
                                          image:nil
                                           type: TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}
#pragma mark image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    CGFloat maxH = sourceImage.size.width == kScreenWidth ?kScreenHeight:kScreenWidth;
    if (sourceImage.size.width < maxH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = maxH;
        btWidth = sourceImage.size.width * (maxH / sourceImage.size.height);
    } else {
        btWidth = maxH;
        btHeight = sourceImage.size.height * (maxH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth*3, btHeight*3);
    return [[self class] imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight+1.0;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (BOOL) isTestServer
{
    if([versionNum rangeOfString:@"beta"].location != NSNotFound)
    {
        return YES;
    }
    NSString * URLString = @"http://www.livenaked.com:8080/hubappversion.json";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    BOOL isTest = NO;
    if (error) {
        NSLog(@"error: %@",[error localizedDescription]);
    }else{
        NSLog(@"response : %@",response);
        NSLog(@"backData : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *Arr = [MTLJSONAdapter modelsOfClass:[APIModel class] fromJSONArray:arr error:nil];
        
        for (APIModel *m in Arr) {
            if ([m.version isEqualToString:versionNum]) {
                isTest = [m.env isEqualToString:@"test"];
            }
        }
    }
    return isTest;
}
+(void)BadgeNumChanged:(BOOL)isBadgeNumAdd
          withBadgeNum:(NSString *)currentBadgeNum
{
    if (isBadgeNumAdd) {
        
        if (currentBadgeNum == nil || currentBadgeNum == NULL
            || [currentBadgeNum isEqualToString:@""]) {
            return ;
        }
        
         NSString  *oldBadgeNum = [[NSUserDefaults standardUserDefaults]objectForKey:BadgeNumKeyForNSUserDefault];
        if ([oldBadgeNum intValue] == [currentBadgeNum intValue]) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:currentBadgeNum forKey:BadgeNumKeyForNSUserDefault];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [oldBadgeNum intValue] != [currentBadgeNum intValue]) {
         
             if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[UITabBarController class]]) {
                 
            UITabBarController *tabbarVC = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
            if (tabbarVC.selectedIndex == 3) {
                //程序当前正处于前台
                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActive" object:nil];
                }
            else{
                 [URLSingleton sharedURLSingleton].isUpDateToday = YES;
            }
        }

    }
}
    else
    {
        
        int badgeNum = [[[NSUserDefaults standardUserDefaults]objectForKey:BadgeNumKeyForNSUserDefault] intValue];
        
        if([currentBadgeNum isEqualToString:@"Read_All"])
            badgeNum = 0;
        else
        badgeNum = badgeNum - [currentBadgeNum intValue];

        currentBadgeNum =[NSString stringWithFormat:@"%d",badgeNum];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentBadgeNum forKey:BadgeNumKeyForNSUserDefault];
        [[NSUserDefaults standardUserDefaults]synchronize];
      
    }
    
    NSLog(@"BadgeNumChanged----   %@",currentBadgeNum);
    
    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[UITabBarController class]]) {
        
            UITabBarController *tabbarVC = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
            if ([currentBadgeNum integerValue] > 0) {
                [((UINavigationController*)tabbarVC.viewControllers[3]).tabBarItem setBadgeValue:currentBadgeNum];
            }
            else{
                
                [((UINavigationController*)tabbarVC.viewControllers[3]).tabBarItem setBadgeValue:nil];
            }
        }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags, alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
    if (iResCode == 0) {
        NSLog(@"success");
    }
}
//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
//重新设置
+(void)resetRootViewController
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *feedNav = [storyBoard instantiateViewControllerWithIdentifier:@"feed"];
    UINavigationController  *exploreNav = [storyBoard instantiateViewControllerWithIdentifier:@"explore"];
    UINavigationController  *messageNav = [storyBoard instantiateViewControllerWithIdentifier:@"message"];
    UINavigationController *todayNav = [storyBoard instantiateViewControllerWithIdentifier:@"today"];
    UINavigationController  *moreNav = [storyBoard instantiateViewControllerWithIdentifier:@"more"];
    
    UITabBarController *tabVC = (UITabBarController*)appDelegate.window.rootViewController;
    tabVC.viewControllers = @[feedNav,exploreNav,messageNav,todayNav,moreNav];
}

+(void)resetRootViewControllerTwo
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *feedNav = [storyBoard instantiateViewControllerWithIdentifier:@"feed"];
    UINavigationController  *exploreNav = [storyBoard instantiateViewControllerWithIdentifier:@"explore"];
    UINavigationController  *messageNav = [storyBoard instantiateViewControllerWithIdentifier:@"message"];
    UINavigationController *todayNav = [storyBoard instantiateViewControllerWithIdentifier:@"today"];
    UINavigationController  *moreNav = [storyBoard instantiateViewControllerWithIdentifier:@"more"];
    
    UITabBarController *tabVC = (UITabBarController*)appDelegate.window.rootViewController;
    tabVC.viewControllers = @[feedNav,exploreNav,messageNav,todayNav,moreNav];
    tabVC.selectedIndex =  2;
}


@end

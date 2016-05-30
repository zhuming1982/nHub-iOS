//
//  Utility.h
//  NakedHub
//
//  Created by 朱明 on 16/3/9.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSMessage.h"
@interface Utility : NSObject
+ (BOOL) isEmpty:(NSString *) str;
+ (BOOL)isiPhone4;
+ (BOOL)isiPhone5;
+ (BOOL)isiPhone6;
+ (BOOL)isiPhone6p;
+(CGFloat)carouselViewHeight;
+(CGFloat)PaymentListViewHeight;
+ (nullable NSString*)getYYYYMMDDG:(NSDate* __nonnull)aDate;
+ (nullable NSString*)getYYYYMMDDWithIntG:(long long)time;
+ (void) showErrorWithVC:(UIViewController*)vc
              andMessage:(NSString*)msg
                andBlock:(void (^)())block;

+ (nullable id )GetViewControllerWithStoryboard:( NSString* __nonnull)StoryboardName
                            andViewController:(NSString* __nonnull)controllerName;
+ (nullable UIViewController*)pushViewControllerWithStoryboard:(NSString* __nonnull)StoryboardName
                                             andViewController:(NSString* __nonnull)controllerName
                                                     andParent:(UIViewController* __nonnull)parent;
+(void) showErrorWithVC:(UIViewController* __nonnull)vc andMessage:(NSString* __nonnull)msg;
+ (void) showSuccessWithVC:(UIViewController* __nonnull)vc andMessage:(NSString* __nonnull)msg;

+ (BOOL) isTestServer;
 id  loadObjectFromNib(NSString * __nonnull nib, Class cls, id __nonnull  owner);
+ (BOOL)isLocationOK:(CLLocationCoordinate2D)location;
+(void)configSubView:(UIView* __nonnull)view CornerWithRadius:(CGFloat)radius;
+ (nullable UIImage *)imageByScalingToMaxSize:(UIImage * __nonnull)sourceImage;
+ (nullable NSString*)getYYYYMMDD:(NSDate* __nonnull)aDate;
+( nullable NSString*)arrTostrWithArr:(NSArray* __nonnull)arr;
+ (void )loginResultAndBlock:(void (^)(id __nonnull response, EMError * __nonnull error))block;
+ (void) logOutWithVC:(UIViewController* _Nullable)vc
           andIsCycle:(BOOL)isCycle;
+ ( nullable NSString*)getYYYYMMDDWithInt:(long long)time;
+ (nullable NSString*)ZYY:(NSInteger)mInt;
+ (nullable NSString*)getHHMM:(NSDate* __nonnull)aDate;
+ (nullable NSString*)getYYYYMMDDHHMM:(NSDate* __nonnull)aDate;
//单年
+ (nullable NSString*)getYearWithInt:(long long)time;
+ (nullable NSString*)getYear:(NSDate* __nonnull)aDate;
//单月
+ (nullable NSString*)getMonthWithInt:(long long)time;
+ (nullable NSString*)getMonth:(NSDate* __nonnull)aDate;
//单日
+ (nullable NSString*)getDayWithInt:(long long)time;
+ (nullable NSString*)getDay:(NSDate* __nonnull)aDate;
//小时分钟
+ (nullable NSString*)getHourMinuteWithInt:(long long)time;
+ (nullable NSString*)getHHMMSS:(NSDate* __nonnull)aDate;
//全写月
+ (nullable NSString*)C_ZYY:(NSInteger)mInt;

// 时间格式转换为： 如果是今天转为： Today，4月 2016 ，否则显示为：18 4月 2016
+ (nullable NSString*)get_book_YYYYMMDD:(NSDate* __nonnull)aDate;

/* 时间格式转换为: 日 月 年 */
+ (nullable NSString*)get_DDMMYYYY:(NSDate* __nonnull)aDate;

// BadgeNum  
+(void)BadgeNumChanged:(BOOL)isBadgeNumAdd withBadgeNum:(NSString *__nonnull)newBadgeNum;
//通过当前语言设置时间格式
+(void)currentLanguange:(NSDateFormatter * __nonnull)formatter;

+(void)resetRootViewController;
+(void)resetRootViewControllerTwo;
+ (UIAlertView *) showErrorMessage:(NSString*)msg;
@end







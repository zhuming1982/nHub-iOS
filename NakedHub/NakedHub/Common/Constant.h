//
//  Constant.h
//  swiftmi_oc
//
//  Created by wings on 7/27/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum tagName {
    
    FromBenifit = 1,
    FromPayment = 2,
    FromWhatDescription = 3,
    FromEvents=4,
    FromGuide = 5,
    FromCommunity=6,
    FromSupport = 7,
    
 }tagName;

//static NSString  *link_pre = @"";

#define urlClass    [URLSingleton sharedURLSingleton]

#define benefit_en    [NSString stringWithFormat:@"%@app/benefits/index.html",urlClass.urlStr]
#define benefit_zh    [NSString stringWithFormat:@"%@app/benefits/index_cn.html",urlClass.urlStr]

#define events_en     @"http://livenaked.com/hub/naked-Hub-happenings.html"
#define events_zh     @"http://livenaked.com/hub/naked-Hub-happenings-cn.html"

#define payment_en  [NSString stringWithFormat:@"%@app/about/terms.html",urlClass.urlStr]
#define payment_zh  [NSString stringWithFormat:@"%@app/about/terms.html",urlClass.urlStr]

#define what_en     [NSString stringWithFormat:@"%@app/about/teamcode.html",urlClass.urlStr]
#define what_zh     [NSString stringWithFormat:@"%@app/about/teamcode_cn.html",urlClass.urlStr]

#define community_en    [NSString stringWithFormat:@"%@app/about/community.html",urlClass.urlStr]
#define community_zh      [NSString stringWithFormat:@"%@app/about/community_cn.html",urlClass.urlStr]


#define guide_en    [NSString stringWithFormat:@"%@app/about/faq.html",urlClass.urlStr]
#define guide_zh    [NSString stringWithFormat:@"%@app/about/faq.html",urlClass.urlStr] 

#define mixPanel     [Mixpanel sharedInstance]

#define versionNum   [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]]

#define user_Id      [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]]

#define mixLanguage [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)]

#define logInDic [NSDictionary dictionaryWithObjectsAndKeys:user_Id,@"userId", versionNum, @"version", mixLanguage, @"locale", nil]
#define logOutDic [NSDictionary dictionaryWithObjectsAndKeys:versionNum, @"version", mixLanguage, @"locale", nil]

#define changeLanguageNoti    @"changeLanguage"
#define SkipToPage            @"skipToPage"

#define BadgeNumKeyForNSUserDefault  @"countUnReadMessage"
#define APPFRAME    [UIScreen mainScreen].applicationFrame
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define userLatitude [LocationManager shared].userLocation.coordinate.latitude
#define userlongitude [LocationManager shared].userLocation.coordinate.longitude
#define nakedHubDelegate  ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define IntToString(a)  [NSString stringWithFormat:@"%d",a]

#define handle_tap(view, delegate, selector) do {\
view.userInteractionEnabled = YES;\
[view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:delegate action:selector]];\
} while(0)


extern NSString* const kPostMessage;
extern NSString * const kImageToUploadNameDic;
extern NSString* const tokenName;
extern NSString* const localeLanguage;
extern NSString* const enteredAppAlready;
extern NSString* const lastEnteredVersion;
extern CGFloat const kTopBarHeight;
extern CGFloat const kGroupTableViewTopOffset;
extern NSString * const kPriceCellIdentifier;
extern NSString * const kUserIdName;
extern NSString * const kUserName;
extern NSString * const kUserAvatarUrl;
extern double const kShowHintSecond;
extern NSString * const kDeviceTokenName;
extern NSString * const kUDIDName;
extern NSString * const kNotification;
extern NSString * const kRemindTime;
extern NSString * const kRemindSwitch;
extern NSString * const kPhoneNumberName;
extern NSInteger const kPageSize;
extern NSString * const kTagListFileName;
extern NSString * const kDateFormateYMD;
extern NSString * const kDateFormateYMDHM;
extern NSString * const kDateFormateHM;
extern NSString * const kFinishCreateOrEditActivity;
extern NSString * const kReservePlaceSuccess;
extern NSString * const kSelectPlaceForActivity;
extern NSInteger const kMinActivityMemberCount;
extern NSInteger const kMaxActivityMemberCount;
extern NSString * const kFavoriteStatusName;
extern NSString * const kAliImageSuffix;
extern NSString * const kEnrollCompetitionSuccess;
extern NSString * const kImageToUploadInDic;
extern NSString * const kDistrictVersion;
extern NSString * const kShangHaiCode;
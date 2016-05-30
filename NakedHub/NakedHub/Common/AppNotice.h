//
//  AppNotice.h
//  swiftmi_oc
//
//  Created by wings on 8/5/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
typedef NS_ENUM(NSInteger, NoticeType) {
    NoticeTypeSuccess,
    NoticeTypeError,
    NoticeTypeInfo,
};


@interface AppNotice : NSObject
+(void)clear;
+(void)wait;
+(void)showText:(NSString*)text;
+(void)showNoticeWithText:(NoticeType)type text:(NSString*)text autoClear:(BOOL)autoClear;

@end

@interface NoticeSDK : NSObject 
+(void)draw:(NoticeType)type;
+(UIImage*)imageOfCheckmark;
+(UIImage*)imageOfCross;
+(UIImage*)imageOfInfo;
@end
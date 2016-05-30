//
//  GDLocalizableClass.h
//  NakedHub
//
//  Created by Winky on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDLocalizableClass : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言


+(NSString *)getStringForKey:(NSString *)key;

+(NSString *)getStringForKey:(NSString *)key withComment:(NSString *)comment;

@end

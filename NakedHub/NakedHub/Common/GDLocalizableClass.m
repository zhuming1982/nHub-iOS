//
//  GDLocalizableClass.m
//  NakedHub
//
//  Created by Winky on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "GDLocalizableClass.h"

static NSBundle *bundle = nil;

@implementation GDLocalizableClass

+ ( NSBundle * )bundle{
    return bundle;
}
+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+(NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

+(NSString *)getStringForKey:(NSString *)key
{
    if (bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, @"Localizable", @"");
}


+(NSString *)getStringForKey:(NSString *)key withComment:(NSString *)comment
{
    if (bundle)
    {
        if (comment.length>0) {
            return NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, comment);
        }
        return NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, @"");
    }
    
    if (comment.length > 0)
        return NSLocalizedStringFromTable(key, @"Localizable", comment);
    else
        return NSLocalizedStringFromTable(key, @"Localizable", @"");
}


@end

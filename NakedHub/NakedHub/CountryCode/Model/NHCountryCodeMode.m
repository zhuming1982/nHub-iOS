//
//  NHCountryCodeMode.m
//  NakedHub
//
//  Created by 施豪 on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//
//
//"id": 4,
//"name": "阿富汗",
//"level": "COUNTRY",
//"phoneCode": "93",
//"index": "A"

#import "NHCountryCodeMode.h"

@implementation NHCountryCodeMode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"name": @"name",
             @"level":@"level",
             @"phoneCode":@"phoneCode",
             @"index":@"index",
             };
}

@end

//
//  APIModel.m
//  NakedHub
//
//  Created by zhuming on 16/4/28.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "APIModel.h"

@implementation APIModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"version":@"version",
             @"env": @"env"
             };
}


@end

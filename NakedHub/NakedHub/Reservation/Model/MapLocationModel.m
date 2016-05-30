//
//  MapLocationModel.m
//  NakedHub
//
//  Created by 施豪 on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "MapLocationModel.h"

@implementation MapLocationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"latitude":@"latitude",
             @"longitude": @"longitude",
             };
}

@end

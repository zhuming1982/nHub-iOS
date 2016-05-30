//
//  NakedHubLocationModel.m
//  NakedHub
//
//  Created by zhuming on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubLocationModel.h"

@implementation NakedHubLocationModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"latitude":@"latitude",
             @"longitude": @"longitude"
             };
}
@end

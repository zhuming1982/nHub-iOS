//
//  NakedHubModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubModel.h"

@implementation NakedHubModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address":@"address",
             @"name":@"name",
             @"picture":@"picture",
             @"wifiName":@"wifiName",
             @"wifiPassword":@"wifiPassword",
             @"hubId":@"id",
             @"seats":@"seats",
             @"version":@"version",
             @"phone":@"phone",
             @"location":@"location",
             @"remainingTimes":@"remainingTimes",
             @"quotaCost4MeetingRoom":@"quotaCost4MeetingRoom",
             @"quotaCost4WorkSpace":@"quotaCost4WorkSpace"
            };
}

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubLocationModel class]];
}



@end

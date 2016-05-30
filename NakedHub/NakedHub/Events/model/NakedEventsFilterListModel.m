//
//  NakedEventsFilterListModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilterListModel.h"

@implementation NakedEventsFilterListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"filterId" : @"id",
             };
}

@end

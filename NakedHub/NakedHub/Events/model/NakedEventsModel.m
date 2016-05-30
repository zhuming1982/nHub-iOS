//
//  NakedEventsModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsModel.h"

#import "NakedHubModel.h"

@implementation NakedEventsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"background" : @"background",
             @"eventsDescription" : @"description",
             @"startTime" : @"startTime",
             @"endTime" : @"endTime",
             @"title" : @"title",
             @"hub" : @"hub",
             @"eventsId" : @"id",
             };
}

+ (NSValueTransformer *)hubJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}

@end

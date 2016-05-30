//
//  NakedEventsDetailModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailModel.h"

#import "NakedHubModel.h"
#import "NakedEventsAttendeesModel.h"

@implementation NakedEventsDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"background" : @"background",
             @"eventsDescription" : @"description",
             @"startTime" : @"startTime",
             @"endTime" : @"endTime",
             @"shareUrl" : @"shareUrl",
             @"title" : @"title",
             @"hub" : @"hub",
             @"eventsId" : @"id",
             @"participators" : @"participators",
             @"attended" : @"attended",
             @"canAttend" : @"canAttend",
             @"participatorCount" : @"participatorCount"
             };
}

+ (NSValueTransformer *)hubJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}

+ (NSValueTransformer *)participatorsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedEventsAttendeesModel class]];
}

@end

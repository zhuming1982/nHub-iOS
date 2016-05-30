//
//  SearchModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchModel.h"

#import "NakedUserModel.h"
#import "NHCompaniesDetailsModel.h"
#import "NakedEventsModel.h"
#import "NakedHubFeedModel.h"

@implementation SearchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"count" : @"count",
             @"resultUnitType" : @"resultUnitType",
             @"users" : @"users",
             @"companies" : @"companies",
             @"events" : @"events",
             @"feeds" : @"feeds"
             };
}

+ (NSValueTransformer *)usersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedUserModel class]];
}

+ (NSValueTransformer *)companiesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NHCompaniesDetailsModel class]];
}

+ (NSValueTransformer *)eventsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedEventsModel class]];
}

+ (NSValueTransformer *)feedsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedHubFeedModel class]];
}

@end

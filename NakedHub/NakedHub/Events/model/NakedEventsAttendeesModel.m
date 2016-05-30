//
//  NakedEventsAttendeesModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsAttendeesModel.h"

#import "NHCompaniesDetailsModel.h"
#import "NakedHubModel.h"

@implementation NakedEventsAttendeesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title" : @"title",
             @"nickname" : @"nickname",
             @"attendId" : @"id",
             @"portait" : @"portait",
             @"background" : @"background",
             @"hub" : @"hub",
             @"company" : @"company"
             };
}

+ (NSValueTransformer *)companyJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NHCompaniesDetailsModel class]];
}

+ (NSValueTransformer *)hubJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}


@end

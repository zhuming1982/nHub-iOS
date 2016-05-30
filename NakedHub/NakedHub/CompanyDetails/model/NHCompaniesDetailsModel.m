//
//  NHCompaniesDetailsModel.m
//  NakedHub
//
//  Created by 施豪 on 16/3/31.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHCompaniesDetailsModel.h"
#import "NakedUserModel.h"

@implementation NHCompaniesDetailsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"name",
             @"id":@"id",
             @"memberCount":@"memberCount",
             @"email":@"email",
             @"phone":@"phone",
             @"website":@"website",
             @"introduction":@"introduction",
             @"logo":@"logo",
             @"background":@"background",
             @"services":@"services",
             @"members":@"members",
             @"followed":@"followed",
             @"followers":@"followers",
             @"isOwner":@"isOwner",
             @"contact":@"contact",
             @"hub":@"hub",
             @"address":@"address"
             };
}

+ (NSValueTransformer *)contactJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedContactModel class]];
}

+ (NSValueTransformer *)hubJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}

+ (NSValueTransformer *)membersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedUserModel class]];
}

+ (NSValueTransformer *)servicesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ExporeServicesModel class]];
}








@end

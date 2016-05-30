//
//  GYUserModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedUserModel.h"

@implementation NakedUserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"background":@"background",
             @"birthday": @"birthday",
             @"company":@"company",
             @"contact":@"contact",
             @"createTime":@"createTime",
             @"userDescription":@"description",
             @"email": @"email",
//             @"floor":@"floor",
             @"followers":@"followers",
             @"following":@"following",
             @"gender":@"gender",
             @"hub":@"hub",
             @"userId": @"id",
             @"interests":@"interests",
             @"memberType":@"memberType", 
             @"mobile":@"mobile",
             @"nickname":@"nickname",
             @"portait": @"portait",
             @"skills":@"skills",
             @"status":@"status",
             @"times":@"times",
             @"title":@"title",
             @"type":@"type",
             @"updateTime": @"updateTime",
             @"website":@"website",
             @"work":@"work",
             @"followed":@"followed"
             };
}

+ (NSValueTransformer *)companyJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NHCompaniesDetailsModel class]];
}
+ (NSValueTransformer *)contactJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedContactModel class]];
}
+ (NSValueTransformer *)hubJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}
+ (NSValueTransformer *)memberTypeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedMemberTypeModel class]];
}




@end

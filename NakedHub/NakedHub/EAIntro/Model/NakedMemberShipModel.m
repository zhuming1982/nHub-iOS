//
//  NakedMemberShipModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedMemberShipModel.h"

@implementation NakedMemberShipModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"memberShipId":@"id",
             @"membershipType": @"membershipType",
             @"name":@"name",
             @"price":@"price",
             @"quotaPerMonth":@"quotaPerMonth",
             @"introduction":@"introduction",
             @"limitedIntroduction":@"limitedIntroduction",
             @"picture":@"picture",
             @"quotaPerMonthIntroduction":@"quotaPerMonthIntroduction"
             };
}
@end

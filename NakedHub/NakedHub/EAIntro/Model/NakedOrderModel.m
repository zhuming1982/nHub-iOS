//
//  NakedOrderModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedOrderModel.h"

@implementation NakedOrderModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"channelTradeNo":@"channelTradeNo",
             @"endDate": @"endDate",
             @"orderId":@"id",
             @"orderStatus":@"orderStatus",
             @"orderTime":@"orderTime",
             @"startDate":@"startDate",
             @"totalTimes":@"totalTimes",
             @"membership":@"membership",
             @"price":@"price"
             };
}

+ (NSValueTransformer *)membershipJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedMemberShipModel class]];
}



@end

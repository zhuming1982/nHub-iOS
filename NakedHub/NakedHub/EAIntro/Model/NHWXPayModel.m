//
//  NHWXPayModel.m
//  NakedHub
//
//  Created by zhuming on 16/4/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHWXPayModel.h"

@implementation NHWXPayModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"appId":@"appId",
             @"nonceStr":@"nonceStr",
             @"packageValue":@"packageValue",
             @"partnerId":@"partnerId",
             @"prepayId":@"prepayId",
             @"sign":@"sign",
             @"timeStamp":@"timeStamp"};
}

@end

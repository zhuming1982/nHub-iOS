//
//  NakedContactModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedContactModel.h"

@implementation NakedContactModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"facebook":@"facebook",
             @"instagram":@"instagram",
             @"linkedin":@"linkedin",
             @"twitter":@"twitter",
             @"wechat":@"wechat"};
}

@end

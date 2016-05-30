//
//  SearchNormalModel.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/20.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchNormalModel.h"

@implementation SearchNormalModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"message" : @"message",
             @"picture" : @"picture",
             @"type" : @"type"
             };
}

@end

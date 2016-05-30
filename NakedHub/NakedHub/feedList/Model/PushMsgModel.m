//
//  PushMsgModel.m
//  NakedHub
//
//  Created by Winky on 16/4/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "PushMsgModel.h"

@implementation PushMsgModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pushSign": @"pushSign",
             @"skipModelId":@"skipModelId",
             @"id":@"id",
             @"refId":@"refId",
             @"skip":@"skip"
             };
}


@end

//
//  NHNotificationsModel.m
//  NakedHub
//
//  Created by 施豪 on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//



#import "NHNotificationsModel.h"

@implementation NHNotificationsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"body":@"body",
             @"id":@"id",
             @"postTime":@"postTime",
             @"pushSign":@"pushSign",
             @"refId":@"refId",
             @"showPicture":@"showPicture",
             @"skipModelClass":@"skipModelClass",
             @"skipModelId":@"skipModelId",
             @"type":@"type",
             @"read":@"read",
             @"skip":@"skip"
             };
}




@end

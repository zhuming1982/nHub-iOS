//
//  NHMeetingRoomModel.m
//  NakedHub
//
//  Created by 施豪 on 16/4/27.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHMeetingRoomModel.h"

@implementation NHMeetingRoomModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"picture":@"picture",
             @"name": @"name",
             };
}
@end

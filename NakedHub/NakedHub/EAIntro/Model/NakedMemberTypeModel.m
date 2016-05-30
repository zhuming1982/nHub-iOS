//
//  NakedMemberTypeModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedMemberTypeModel.h"

@implementation NakedMemberTypeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cnName":@"cnName",
             @"typeId":@"id",
             @"name":@"name",
             @"version":@"version"};
}


@end

//
//  NakedHubCommentsModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubCommentsModel.h"

@implementation NakedHubCommentsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content":@"content",
             @"commentsId": @"id",
             @"liked":@"liked",
             @"likeNum":@"likeNum",
             @"postTime":@"postTime",
             @"user":@"user"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedUserModel class]];
}


@end

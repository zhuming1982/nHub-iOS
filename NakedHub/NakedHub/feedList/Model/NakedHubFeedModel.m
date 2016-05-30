//
//  NakedHubFeedModel.m
//  NakedHub
//
//  Created by zhuming on 16/3/23.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubFeedModel.h"

@implementation NakedHubFeedModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content":@"content",
             @"feedId": @"id",
             @"liked":@"liked",
             @"likeNum":@"likeNum",
             @"commented":@"commented",
             @"commentNum":@"commentNum",
             @"postTime":@"postTime",
             @"pictureAccessPath":@"pictureAccessPath",
             @"user":@"user",
             @"comments":@"comments",
             @"likers":@"likers"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedUserModel class]];
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedHubCommentsModel class]];
}

+ (NSValueTransformer *)likersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedUserModel class]];
}

@end

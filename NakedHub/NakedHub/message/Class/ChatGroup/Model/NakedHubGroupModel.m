//
//  GYGroupModel.m
//  SportSocial
//
//  Created by ZhuMing on 15/11/10.
//  Copyright © 2015年 cloudrui. All rights reserved.
//


#import "NakedHubGroupModel.h"

@implementation NakedHubGroupModel
//+ (NSValueTransformer *)creatorJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedUserModel class]];
//}

//+ (NSValueTransformer *)extJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GYextModel class]];
//}

//+ (NSValueTransformer *)logoJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GYpictureModel class]];
//}

+ (NSValueTransformer *)membersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedUserModel class]];
}
//+ (NSValueTransformer *)memberAvatarsJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[GYpictureModel class]];
//}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
//             @"creator":@"creator",
//             @"ext": @"ext",
             @"huanxinGroupId":@"huanxinGroupId",
//             @"groupDesc":@"groupDesc",
             @"name":@"name",
             @"id":@"id",
             @"logo":@"logo",
             @"members":@"members",
             @"memberAvatars":@"memberAvatars",
//             @"currUserIsMember":@"currUserIsMember",
             };
}

@end

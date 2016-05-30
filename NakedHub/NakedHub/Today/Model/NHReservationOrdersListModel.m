//
//  NHReservationOrdersListModel.m
//  NakedHub
//
//  Created by 施豪 on 16/4/12.
//  Copyright © 2016年 zhuming. All rights reserved.
//

/*
 @property (nonatomic,assign) NSInteger       createTime;
 @property (nonatomic,assign) BOOL            deleted;
 @property (nonatomic,assign) NSInteger       endTime;
 @property (nonatomic,strong) NakedHubModel   *hub;
 @property (nonatomic,assign) NSInteger       id;
 @property (nonatomic,assign) NSInteger       price;
 @property (nonatomic,copy)   NSString        *reservationType;
 @property (nonatomic,assign) NSInteger       startTime;
 @property (nonatomic,assign) NSInteger       updateTime;
 @property (nonatomic,strong) NakedUserModel  *user;
 @property (nonatomic,assign) NSInteger       version;
*/

#import "NHReservationOrdersListModel.h"

@implementation NHReservationOrdersListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"createTime":@"createTime",
             @"deleted":@"deleted",
             @"endTime": @"endTime",
             @"hub":@"hub",
             @"id":@"id",
             @"price":@"price",
             @"reservationType":@"reservationType",
             @"startTime":@"startTime",
             @"updateTime": @"updateTime",
             @"user":@"user",
             @"version":@"version",
             @"meetingRoom":@"meetingRoom"
             };
}

+ (NSValueTransformer *)HubJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}
+ (NSValueTransformer *)BookRoomJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedBookRoomModel class]];
}
+ (NSValueTransformer *)UserJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedUserModel class]];
}
+ (NSValueTransformer *)meetingroomJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NHMeetingRoomModel class]];
}


@end












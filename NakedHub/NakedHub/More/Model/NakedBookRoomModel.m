//
//  NakedBookRoomModel.m
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookRoomModel.h"

@implementation NakedBookRoomModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"floor":@"floor",
             @"hub": @"hub",
             @"roomId":@"id",
             @"name":@"name",
             @"picture":@"picture",
             @"price":@"price",
             @"seats":@"seats",
             @"reservationTimeUnites":@"reservationTimeUnites",
             @"introduction":@"introduction"
             };
}

+ (NSValueTransformer *)hubJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NakedHubModel class]];
}

+ (NSValueTransformer *)reservationTimeUnitesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NakedHubReservationTimeUnitesModel class]];
}



@end

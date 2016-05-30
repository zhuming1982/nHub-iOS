//
//  NakedOrderModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NakedMemberShipModel.h"

@interface NakedOrderModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString               *channelTradeNo;
@property (nonatomic,assign) long long               endDate;
@property (nonatomic,assign) NSInteger             orderId;
@property (nonatomic,strong) NakedMemberShipModel *membership;
@property (nonatomic,copy) NSString               *orderStatus;
@property (nonatomic,assign) long long               orderTime;
@property (nonatomic,assign) long long               startDate;
@property (nonatomic,assign) NSInteger             totalTimes;
@property (nonatomic,assign) double                price;

@end

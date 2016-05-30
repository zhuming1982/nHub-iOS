//
//  NakedHubModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//"address": "string",
//"ext": {},
//"id": 0,
//"name": "string",
//"picture": "string",
//"seats": 0,
//"version": 0,
//"wifiName": "string",
//"wifiPassword": "string"

#import <Mantle/Mantle.h>
#import "NakedHubLocationModel.h"


@interface NakedHubModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString   *address;
@property (nonatomic,copy) NSString   *name;
@property (nonatomic,copy) NSString   *picture;
@property (nonatomic,copy) NSString   *wifiName;
@property (nonatomic,copy) NSString   *wifiPassword;
@property (nonatomic,assign) NSInteger hubId;
@property (nonatomic,assign) NSInteger seats;
@property (nonatomic,assign) NSInteger version;
@property (nonatomic,strong) NakedHubLocationModel *location;
@property (nonatomic,copy) NSString   *phone;
@property (nonatomic,assign) NSInteger remainingTimes;
@property (nonatomic,assign) CGFloat quotaCost4MeetingRoom;
@property (nonatomic,assign) CGFloat quotaCost4WorkSpace;


@end










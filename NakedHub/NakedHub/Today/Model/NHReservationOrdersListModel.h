//
//  NHReservationOrdersListModel.h
//  NakedHub
//
//  Created by 施豪 on 16/4/12.
//  Copyright © 2016年 zhuming. All rights reserved.
//
/*
 "reservationRecords": [
 {
 "createTime": 1460528384000,
 "deleted": false,
 "endTime": 1460541600000,
 "ext": {},
 "hub": {
 "address": "3F-6F, NO.1, 84Nong, Taixing Road (near Wujiang Road), JingAn District",
 "createTime": 1458791362000,
 "deleted": false,
 "ext": {},
 "id": 3,
 "location": {
 "latitude": 31.1926759267,
 "longitude": 121.3625481744
 },
 "name": "West Nanjing Road",
 "phone": "021-1234",
 "picture": "http://naked.img-cn-shanghai.aliyuncs.com/hub3.jpg",
 "seats": 48,
 "updateTime": 1458791362000,
 "version": 0,
 "wifiName": "nakedHub",
 "wifiPassword": "nakedloveme"
 },
 "id": 171903,
 "price": 0,
 "reservationOrder": {},
 "reservationType": "MEETINGROOM",
 "startTime": 1460538000000,
 "updateTime": 1460528384000,
 "user": {
 "background": "http://nakedhubappdev.img-cn-shanghai.aliyuncs.com/4dbf7ba5-1849-4b38-924b-6be3fdce7936.jpg",
 "id": 167679,
 "nickname": "nujian",
 "portait": "http://nakedhubappdev.img-cn-shanghai.aliyuncs.com/a3d66454-91bd-49bd-9b46-f955b30c8921.jpg"
 },
 "version": 0
*/

#import <Mantle/Mantle.h>
#import "NakedHubModel.h"
#import "NakedBookRoomModel.h"
#import "NakedUserModel.h"
#import "NHMeetingRoomModel.h"

@interface NHReservationOrdersListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) long long       createTime;
@property (nonatomic,assign) BOOL            deleted;
@property (nonatomic,assign) long long       endTime;
@property (nonatomic,strong) NakedHubModel   *hub;
@property (nonatomic,assign) NSInteger       id;
@property (nonatomic,assign) NSInteger       price;
@property (nonatomic,copy)   NSString        *reservationType;
@property (nonatomic,assign) long long       startTime;
@property (nonatomic,assign) long long       updateTime;
@property (nonatomic,strong) NakedUserModel  *user;
@property (nonatomic,assign) NSInteger       version;
@property (nonatomic,strong) NHMeetingRoomModel  *meetingRoom;






@end

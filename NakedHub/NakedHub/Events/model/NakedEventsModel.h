//
//  NakedEventsModel.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NakedHubModel;

@interface NakedEventsModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *eventsDescription;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger eventsId;
@property (nonatomic, strong) NakedHubModel *hub;

/*
 {
 description = "\U8bf7\U5230\U4e86\U51e0\U4f4d\U5728\U6559\U80b2\U548c\U79d1\U6280\U9886\U57df\U521b\U4e1a\U7684\U521b\U4e1a\U8005\Uff0c\U901a\U8fc7\U4e00\U573a\U591c\U8bdd\Uff0c\U6765\U63a2\U8ba8\U6570\U636e\U65f6\U4ee3\U7684\U6559\U80b2\U884c\U4e1a\U8be5\U5982\U4f55\U524d\U884c\Uff01";
 endTime = 1463837400000;
 ext =             {
};
 hub =             {
    address = "\U590d\U5174\U4e2d\U8def1237\U53f73\U697c";
    id = 1;
    location =                 {
        latitude = "31.2126739902";
        longitude = "121.4581816372";
        };
    name = "\U590d\U5174\U8def";
    phone = "";
    picture = "http://naked.img-cn-shanghai.aliyuncs.com/hub1.jpg";
 };
 id = 177458;
 startTime = 1463830200000;
 title = "\U54c8\U4f5b\U6821\U53cb\U4f1a";
 },

 */

@end

//
//  NakedEventsDetailModel.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NakedHubModel;
@class NakedEventsAttendeesModel;

@interface NakedEventsDetailModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL attended; // true为已参加
@property (nonatomic, assign) BOOL canAttend; // true为可以参加
@property (nonatomic, assign) NSInteger participatorCount; // 参与人数
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *eventsDescription;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger eventsId;
@property (nonatomic, strong) NSArray<NakedEventsAttendeesModel *> *participators;
@property (nonatomic, strong) NakedHubModel *hub;

@end

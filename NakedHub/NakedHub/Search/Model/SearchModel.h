//
//  SearchModel.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NakedUserModel;
@class NHCompaniesDetailsModel;
@class NakedEventsModel;
@class NakedHubFeedModel;

@interface SearchModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *resultUnitType;

@property (nonatomic, strong) NSArray<NakedUserModel *> *users; // 成员

@property (nonatomic, strong) NSArray<NHCompaniesDetailsModel *> *companies; // 公司

@property (nonatomic, strong) NSArray<NakedEventsModel *> *events; // 活动

@property (nonatomic, strong) NSArray<NakedHubFeedModel *> *feeds; // 帖子

@end

//
//  NakedEventsAttendeesModel.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NHCompaniesDetailsModel;
@class NakedHubModel;

@interface NakedEventsAttendeesModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *portait;
@property (nonatomic, assign) NSInteger attendId;
@property (nonatomic, strong) NHCompaniesDetailsModel *company;
@property (nonatomic, strong) NakedHubModel *hub;

@end

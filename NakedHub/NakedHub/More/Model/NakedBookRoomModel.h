//
//  NakedBookRoomModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NakedHubModel.h"
#import "NakedHubReservationTimeUnitesModel.h"

@interface NakedBookRoomModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,assign) NSInteger      floor;
@property (nonatomic,strong) NakedHubModel *hub;
@property (nonatomic,assign) NSInteger      roomId;
@property (nonatomic,copy) NSString        *name;
@property (nonatomic,copy) NSString        *picture;
@property (nonatomic,assign) NSInteger      price;
@property (nonatomic,assign) NSInteger      seats;
@property (nonatomic,strong) NSArray<NakedHubReservationTimeUnitesModel*> *reservationTimeUnites;
@property (nonatomic,copy) NSString        *introduction;

@end

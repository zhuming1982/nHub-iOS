//
//  NakedHubReservationTimeUnitesModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NakedHubReservationTimeUnitesModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) BOOL allowBook;

@property (nonatomic,copy) NSString *date;

@end

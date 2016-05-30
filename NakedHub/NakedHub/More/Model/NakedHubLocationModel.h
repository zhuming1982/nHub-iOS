//
//  NakedHubLocationModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NakedHubLocationModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;

@end

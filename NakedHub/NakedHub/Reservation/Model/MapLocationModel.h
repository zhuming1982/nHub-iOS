//
//  MapLocationModel.h
//  NakedHub
//
//  Created by 施豪 on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MapLocationModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign)  double   latitude;
@property (nonatomic,assign)  double   longitude;



@end

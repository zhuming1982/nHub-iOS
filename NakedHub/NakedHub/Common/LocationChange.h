//
//  LocationChange.h
//  JinLong
//
//  Created by Seasaw on 15/9/21.
//  Copyright (c) 2015年 Kong. All rights reserved.
//

#import <Foundation/Foundation.h>
void bd_decrypt(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon);
void bd_encrypt(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon);
@interface LocationChange : NSObject

@end

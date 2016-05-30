//
//  LocationManager.h
//  SportSocial
//
//  Created by wings on 15/10/26.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

@property (nonatomic,strong, readonly)CLLocation* userLocation;
- (BOOL) hasGpsRight;

+ (instancetype)shared;

@end

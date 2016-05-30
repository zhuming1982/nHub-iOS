//
//  URLSingleton.h
//  NakedHub
//
//  Created by nanqian on 16/4/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSingleton : NSObject

@property (nonatomic , copy)NSString  *urlStr;
@property (nonatomic , assign) BOOL   isUpDateToday;

+(URLSingleton *)sharedURLSingleton;

@end

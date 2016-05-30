//
//  NakedEventsFilter.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/27.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NakedEventsFilter : NSObject

@property (nonatomic, strong) NSDictionary *filterDictionary;

+ (instancetype)shareInstance;

- (void)initWithFilterDictionary:(NSDictionary *)filterDictionary;

- (NSDictionary *)getFilterDictionary;

- (void)removeFilterDictionary;

@end

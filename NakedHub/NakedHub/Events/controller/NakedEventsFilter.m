//
//  NakedEventsFilter.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/27.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilter.h"

@implementation NakedEventsFilter

+ (instancetype)shareInstance
{
    static NakedEventsFilter *nakedEventsFilter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nakedEventsFilter = [[NakedEventsFilter alloc] init];
    });
    
    return nakedEventsFilter;
}

- (void)initWithFilterDictionary:(NSDictionary *)filterDictionary
{
    _filterDictionary = filterDictionary;
}

- (NSDictionary *)getFilterDictionary
{
    return _filterDictionary;
}

- (void)removeFilterDictionary
{
    _filterDictionary = nil;
}

@end

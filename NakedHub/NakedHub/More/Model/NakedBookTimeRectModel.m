//
//  NakedBookTimeRectModel.m
//  NakedHub
//
//  Created by zhuming on 16/4/6.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookTimeRectModel.h"

@implementation NakedBookTimeRectModel
-(instancetype)initWith:(CGRect)rt andIndex:(NSIndexPath*)ind
{
    if (self = [super init]) {
        
    }
    _rect = rt;
    _index = ind;
    return self;
}
@end

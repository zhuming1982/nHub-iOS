//
//  NakedBookTimeRectModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/6.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NakedBookTimeRectModel : NSObject
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,strong) NSIndexPath *index;

-(instancetype)initWith:(CGRect)rt andIndex:(NSIndexPath*)ind;


@end

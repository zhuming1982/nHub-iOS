//
//  NakedEventsFilterHeaderView.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilterHeaderView.h"

@implementation NakedEventsFilterHeaderView

- (id) init {
    id obj = loadObjectFromNib(@"NakedEventsFilterHeaderView", [NakedEventsFilterHeaderView class], self);
    if (obj) {
        self = (NakedEventsFilterHeaderView *)obj;
    } else {
        self = [self init];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //    //顶部分割线
//    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
//    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
//    
//    //底部分割线
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height -0.5, rect.size.width, 0.5));
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

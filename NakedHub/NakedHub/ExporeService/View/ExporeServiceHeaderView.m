//
//  ExporeServiceHeaderView.m
//  NakedHub
//
//  Created by 施豪 on 16/4/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//
//  UILabel *headlabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0,vc.view.frame.size.width, 44)];
//  headlabel.textAlignment = NSTextAlignmentCenter;
//  [headlabel setText:text];
//  headlabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
//  headlabel.textColor =  [UIColor colorWithRed:136/255.0 green:139/255.0 blue:144/255.0 alpha:1];

#import "ExporeServiceHeaderView.h"

@implementation ExporeServiceHeaderView

- (id) init {
    id obj = loadObjectFromNib(@"ExporeServiceHeaderView", [ExporeServiceHeaderView class], self);
    if (obj) {
        self = (ExporeServiceHeaderView *)obj;
    } else {
        self = [self init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    //    //顶部分割线
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
    //底部分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height -0.5, rect.size.width, 0.5));
    
}

@end

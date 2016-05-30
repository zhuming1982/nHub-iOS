//
//  NHCollectionView.m
//  NakedHub
//
//  Created by zhuming on 16/4/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHCollectionView.h"
#import "NakedBookRoomSelectTimeView.h"

@implementation NHCollectionView
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view
{
    
    if ([view isKindOfClass:[NakedBookRoomSelectTimeView class]]) {
        return NO;
    }
    
    return YES;
}
// called before scrolling begins if touches have already been delivered to a subview of the scroll view. if it returns NO the touches will continue to be delivered to the subview and scrolling will not occur
// not called if canCancelContentTouches is NO. default returns YES if view isn't a UIControl
// this has no effect on presses
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

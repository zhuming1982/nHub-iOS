//
//  CloseKeyboradOnBlankArea.m
//  SportSocial
//
//  Created by songwei on 15/9/30.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "CloseKeyboradOnBlankArea.h"

@implementation CloseKeyboradOnBlankAreaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *result = [super hitTest:point withEvent:event];
    // You can change the following condition to meet your own needs
    if (![result isMemberOfClass:[UITextField class]]
        && ![result isMemberOfClass:[UITextView class]]
        && ![result isMemberOfClass:[UIButton class]]) {
        [self endEditing:YES];
    }
    return result;
}

@end


@implementation CloseKeyboradOnBlankAreaTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    // You can change the following condition to meet your own needs
    if (![result isMemberOfClass:[UITextField class]]
        && ![result isMemberOfClass:[UITextView class]]
        && ![result isMemberOfClass:[UIButton class]]) {
        [self endEditing:YES];
    }
    return result;
}


@end
//
//  NakedBookRoomSelectTimeView.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookRoomSelectTimeView.h"
#import "NakedPullImageView.h"
#import "NakedBookRoomSelectTimeCell.h"

@implementation NakedBookRoomSelectTimeView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    self.backgroundColor = [UIColor orangeColor];
    self.userInteractionEnabled = YES;
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_TouchBegin) {
        _TouchBegin([touches anyObject]);
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_TouchMove) {
        _TouchMove([touches anyObject]);
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_TouchEnd) {
        _TouchEnd([touches anyObject]);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  ExporeServiceFooterView.m
//  NakedHub
//
//  Created by 施豪 on 16/4/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ExporeServiceFooterView.h"

@implementation ExporeServiceFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init {
    id obj = loadObjectFromNib(@"ExporeServiceFooterView", [ExporeServiceFooterView class], self);
    if (obj) {
        self = (ExporeServiceFooterView *)obj;
    } else {
        self = [self init];
    }
    return self;
}


@end

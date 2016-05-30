//
//  SearchFooterView.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchFooterView.h"

@implementation SearchFooterView

- (id) init {
    id obj = loadObjectFromNib(@"SearchFooterView", [SearchFooterView class], self);
    if (obj) {
        self = (SearchFooterView *)obj;
    } else {
        self = [self init];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

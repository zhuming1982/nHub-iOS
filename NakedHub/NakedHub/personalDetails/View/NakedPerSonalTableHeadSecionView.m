//
//  NakedPerSonalTableHeadSecionView.m
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPerSonalTableHeadSecionView.h"
#import "Utility.h"

@implementation NakedPerSonalTableHeadSecionView



- (id) init {
    id obj = loadObjectFromNib(@"NakedPerSonalTableHeadSecionView", [NakedPerSonalTableHeadSecionView class], self);
    if (obj) {
        self = (NakedPerSonalTableHeadSecionView *)obj;
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

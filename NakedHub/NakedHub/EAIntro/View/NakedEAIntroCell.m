//
//  NakedEAIntroCell.m
//  NakedHub
//
//  Created by 朱明 on 16/3/8.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedEAIntroCell.h"
#import "Utility.h"

@implementation NakedEAIntroCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if([Utility isiPhone4])
    {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        _topConstraint.constant = 10;
        _middleConstraint.constant = 12;
        _leftConstraint.constant = 26;
        _rightConstraint.constant = 26;
    }
    
    if ([Utility isiPhone5]) {
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        _topConstraint.constant = 10;
        _middleConstraint.constant = 12;
        _leftConstraint.constant = 26;
        _rightConstraint.constant = 26;
    }
    if ([Utility isiPhone6p]) {
        self.titleLabel.font = [UIFont systemFontOfSize:22];
        self.contentLabel.font = [UIFont systemFontOfSize:18];
        _topConstraint.constant = 28;
        _middleConstraint.constant = 30;
    }
}


@end

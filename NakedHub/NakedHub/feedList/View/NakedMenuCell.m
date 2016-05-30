//
//  NakedMenuCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedMenuCell.h"

@implementation NakedMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:0 alpha:1.0];
    }
    else
    {
        _titleLabel.textColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end

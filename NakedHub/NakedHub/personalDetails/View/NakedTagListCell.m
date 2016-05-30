//
//  NakedTagListCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedTagListCell.h"

@implementation NakedTagListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    SKTag *tag = [SKTag tagWithText:[GDLocalizableClass getStringForKey:@"Take Photo"]];
    tag.textColor = [UIColor whiteColor];
    tag.font = [UIFont fontWithName:@"Avenir-Heavy" size:14];
    tag.enable = NO;
    tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    tag.bgColor = [UIColor colorWithRed:38.0/255.0 green:171.0/255.0 blue:240.0/255.0 alpha:1.0];
    tag.cornerRadius = 15;
    [self.tagView addTag:tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)separate:(UIButton *)sender {
    
}
@end

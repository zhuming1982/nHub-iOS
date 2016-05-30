//
//  topCell.m
//  NakedHub
//
//  Created by nanqian on 16/4/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "topCell.h"

@implementation topCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.topCellContent setText:[GDLocalizableClass getStringForKey:@"Enter your mobile number below."]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

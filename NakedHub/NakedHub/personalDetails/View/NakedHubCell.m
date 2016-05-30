//
//  NakedHubCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubCell.h"

@implementation NakedHubCell

- (void)setHubModel:(NakedHubModel *)hubModel
{
    _hubNameLabel.text = hubModel.name;
    _hubAddressLabel.text = hubModel.address;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
    // Configure the view for the selected state
}

@end

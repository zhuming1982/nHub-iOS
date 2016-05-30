//
//  NakedBookAddressCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookAddressCell.h"

@implementation NakedBookAddressCell

-(void) setHubModel:(NakedHubModel *)hubModel
{
    if (hubModel) {
        _hubModel = hubModel;
        _hubNameLabel.text = hubModel.name;
        _addressLabel.text = hubModel.address;
    }
    else
    {
       _hubNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        _addressLabel.text = [GDLocalizableClass getStringForKey:@"PLEASE SELECT LOCATION"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

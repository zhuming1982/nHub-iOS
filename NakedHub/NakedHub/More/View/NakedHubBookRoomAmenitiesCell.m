//
//  NakedHubBookRoomAmenitiesCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBookRoomAmenitiesCell.h"

@implementation NakedHubBookRoomAmenitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.titleLabel setText:[GDLocalizableClass getStringForKey:@"AMENITIES"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

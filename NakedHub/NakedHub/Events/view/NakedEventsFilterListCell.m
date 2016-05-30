//
//  NakedEventsFilterListCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilterListCell.h"

#import "NakedEventsFilterListModel.h"

@implementation NakedEventsFilterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [Utility configSubView:_chooseImageView CornerWithRadius:4.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    _filterLabel.textColor = selected ? RGBACOLOR(233.0, 144.0, 29.0, 1) : RGBACOLOR(136.0, 139.0, 144.0, 1.0);
    _chooseImageView.image = selected ? [UIImage imageNamed:@"filterSelect"] : nil;
}

- (void)setFilterListModel:(NakedEventsFilterListModel *)filterListModel
{
    _filterListModel = filterListModel;
    
    _filterLabel.text = _filterListModel.name;
}

@end

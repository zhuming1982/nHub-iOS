//
//  NakedHubMoreCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/25.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubMoreCell.h"

@implementation NakedHubMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_numBadge) {
        _numBadge = [[JSBadgeView alloc] initWithParentView:self.subTitleLabel alignment:JSBadgeViewAlignmentCenterLeft];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NakedEventsDetailInfoCollectionViewCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailInfoCollectionViewCell.h"

@implementation NakedEventsDetailInfoCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end

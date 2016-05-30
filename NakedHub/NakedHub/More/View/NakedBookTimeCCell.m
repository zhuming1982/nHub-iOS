//
//  NakedBookTimeCCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookTimeCCell.h"

@implementation NakedBookTimeCCell

- (void) setModel:(NakedHubReservationTimeUnitesModel *)model
     andHalfModel:(NakedHubReservationTimeUnitesModel *)halfModel
{
    _model = model;
    _halfModel = halfModel;
    _leftConstraint.constant = model.allowBook?self.frame.size.width/2:0;
    _rightConstraint.constant = halfModel.allowBook?self.frame.size.width/2:0;
    _timeLabel.text = model.date;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    _figureView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tiledpattern"]];
}

@end

//
//  NakedPaymentCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPaymentCell.h"

@implementation NakedPaymentCell


-(void) setOrderModel:(NakedOrderModel *)orderModel
{
    _pricePlusLabel.text = orderModel.membership.name;
    _priceNumberLabel.text = [NSString stringWithFormat:@"¥%.f",orderModel.price];
    _daysLabel.text = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%li months"],(long)orderModel.totalTimes/orderModel.membership.quotaPerMonth];
    _dayMonthLabel.text = orderModel.membership.limitedIntroduction;
    _typeLabel.text = orderModel.membership.quotaPerMonthIntroduction;
    _dateLabel.text = [NSString stringWithFormat:@"%@-%@",[Utility getYYYYMMDDWithIntG:orderModel.startDate],[Utility getYYYYMMDDWithIntG:orderModel.endDate]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

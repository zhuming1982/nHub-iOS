//
//  NakedPaymentCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedOrderModel.h"

@interface NakedPaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pricePlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) NakedOrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UILabel *dayMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

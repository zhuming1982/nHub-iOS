//
//  NakedBookAddressCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedBookAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,strong) NakedHubModel *hubModel;

@end

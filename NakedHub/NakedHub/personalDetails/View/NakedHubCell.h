//
//  NakedHubCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubModel.h"

@interface NakedHubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hubAddressLabel;
@property (nonatomic,strong)NakedHubModel *hubModel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

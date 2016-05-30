//
//  NakedHubMoreCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/25.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface NakedHubMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic ,strong) JSBadgeView *numBadge;



@end

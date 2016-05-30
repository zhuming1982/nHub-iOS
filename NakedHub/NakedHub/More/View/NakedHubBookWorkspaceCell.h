//
//  NakedHubBookWorkspaceCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubModel.h"

@interface NakedHubBookWorkspaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *workSpaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *bookNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (copy, nonatomic) void (^bookNowCallBack)();

- (IBAction)bookNowAction:(UIButton *)sender;

@property (nonatomic,strong) NakedHubModel *hubModel;





@end

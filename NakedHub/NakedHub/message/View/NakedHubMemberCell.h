//
//  NakedHubMemberCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/31.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedUserModel.h"
@interface NakedHubMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (nonatomic,strong) NakedUserModel *userModel;

@end

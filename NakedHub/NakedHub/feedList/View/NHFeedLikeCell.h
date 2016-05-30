//
//  NHFeedLikeCell.h
//  NakedHub
//
//  Created by zhuming on 16/5/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedUserModel.h"

@interface NHFeedLikeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (nonatomic,strong)NakedUserModel *user;

@end

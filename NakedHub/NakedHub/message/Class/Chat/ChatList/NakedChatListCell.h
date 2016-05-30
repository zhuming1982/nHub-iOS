//
//  NakedChatListCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedChatListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HeadPortraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *promptPointView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end

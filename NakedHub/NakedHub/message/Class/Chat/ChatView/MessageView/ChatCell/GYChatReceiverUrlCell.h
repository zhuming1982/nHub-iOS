//
//  GYChatUrlCell.h
//  SportSocial
//
//  Created by ZhuMing on 15/11/18.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYChatReceiverUrlCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (weak, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageBgView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventIconView;
@property (weak, nonatomic) IBOutlet UILabel     *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *eventAdressLabel;

@property (nonatomic,strong) void (^selectEventDetail)(GYChatReceiverUrlCell *Cell);

- (IBAction)selectEvent:(UITapGestureRecognizer *)sender;

@end

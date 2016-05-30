//
//  NotificationsTableViewCell.h
//  NakedHub
//
//  Created by 施豪 on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHNotificationsModel.h"
#import "NHReservationOrdersListModel.h"

@interface NotificationsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Left_image;
@property (weak, nonatomic) IBOutlet UILabel *Title_label;
@property (weak, nonatomic) IBOutlet UILabel *Time_label;
@property (weak, nonatomic) IBOutlet UIImageView *red_image;
@property (nonatomic,strong) NHNotificationsModel *NotificationsModel;
@property (nonatomic,strong) NHReservationOrdersListModel *ReservationOrdersListModel;


@end

//
//  NHReservationListTableViewCell.h
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHReservationOrdersListModel.h"

@interface NHReservationListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_name;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *top_time_label;
@property (weak, nonatomic) IBOutlet UILabel *bottom_tim_label;
@property (weak, nonatomic) IBOutlet UIImageView *bot_image;
@property (weak, nonatomic) IBOutlet UIView *background_view;
@property (weak, nonatomic) IBOutlet UIView *showview;//底层阴影view
@property(strong, nonatomic)NHReservationOrdersListModel *ReservationOrdersListModel;


@property (nonatomic,copy)void (^buttonActionBlock)(UIButton *btn);
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
- (IBAction)Cancel_act:(id)sender;
@property (nonatomic,copy)void (^CancelActionBlock)(UIButton *btn);

//标题与左边模块间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_space;



@end









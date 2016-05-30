//
//  NHReservationDetailTableViewCell.h
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHReservationOrdersListModel.h"

@interface NHReservationDetailTableViewCell : UITableViewCell<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *TOP_imageVIew;///顶部图
@property (weak, nonatomic) IBOutlet UILabel *date_lab;///日期
@property (weak, nonatomic) IBOutlet UILabel *title_label;///标题名
@property (weak, nonatomic) IBOutlet UILabel *time_label;///时间点
@property (weak, nonatomic) IBOutlet MKMapView *My_Map;///地图
@property (weak, nonatomic) IBOutlet UILabel *address_lab;///地址
@property (weak, nonatomic) IBOutlet UILabel *phone_lab;///电话

@property(strong, nonatomic)NHReservationOrdersListModel *ReservationOrdersListModel;







@end

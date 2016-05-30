//
//  NHReservationsListViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/4/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHReservationOrdersListModel.h"

@interface NHReservationsDetailViewController: UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NHReservationOrdersListModel  *Model;
@property (nonatomic,copy)   NSString *haha;
@property (nonatomic, assign) NSInteger Reservation_id;//参数
@property (nonatomic,assign) BOOL     is_mores;

@property (weak, nonatomic) IBOutlet UITableView *Detail_tableview;
- (IBAction)nav_back:(UIBarButtonItem *)sender;
//取消按钮
- (IBAction)Cancel_btn:(UIButton *)sender;
@property (nonatomic,copy) void (^PopDVCBack)();
@property (nonatomic,copy) void (^PopBack)(NSInteger Model_id);
@property (weak, nonatomic) IBOutlet UIButton *Cancel_out;

@property (nonatomic,copy) void (^PopNotification)(BOOL isCancel);


@end

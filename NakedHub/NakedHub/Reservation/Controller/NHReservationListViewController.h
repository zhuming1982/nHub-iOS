//
//  NHReservationListViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHReservationListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tablelistview;

@property (nonatomic,copy) void (^PopBack)();
@property (nonatomic,copy) void (^PopddsBack)(NSArray *cancel_arr);
@property (nonatomic,assign) BOOL     is_more;
@property (nonatomic,assign) BOOL     is_Cancel;
@property (nonatomic,copy)   NSString        *NotType_str;


@end

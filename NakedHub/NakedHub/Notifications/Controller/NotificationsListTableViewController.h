//
//  NotificationsListTableViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsListTableViewController : UITableViewController
@property (nonatomic,copy) void (^readBOOL)(NSArray *arrayData);
@property (nonatomic,copy)   NSString        *NotType_str;


@end

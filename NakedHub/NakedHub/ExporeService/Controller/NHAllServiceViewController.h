//
//  NHAllServiceViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHAllServiceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView  *allservice_tableview;
@property (nonatomic,copy) void (^PopBack)();


@end

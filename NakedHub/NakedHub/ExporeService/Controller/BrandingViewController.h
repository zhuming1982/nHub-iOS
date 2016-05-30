//
//  BrandingViewController.h
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *B_tableview;
@property (nonatomic, assign) NSInteger service_id;
@property (nonatomic,copy) void (^PopBack)();


@end

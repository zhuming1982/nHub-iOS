//
//  NakedHubBWSDViewController.h
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubModel.h"

@interface NakedHubBWSDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *cancelRule;
@property (nonatomic,strong) NSDate *selectDate;

@property (nonatomic,strong)NakedHubModel *hubModel;

@property (nonatomic,copy) void (^ConferenceHubSucessCallBack)();

@end

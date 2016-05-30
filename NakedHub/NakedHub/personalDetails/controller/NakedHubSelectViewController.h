//
//  NakedHubSelectViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubModel.h"

@interface NakedHubSelectViewController : UITableViewController

@property (nonatomic,strong) NakedHubModel*selectModel;

@property (nonatomic,copy) void (^selectHubCallBack)(NakedHubModel*model);

@property (nonatomic,assign) BOOL isBook;

@end

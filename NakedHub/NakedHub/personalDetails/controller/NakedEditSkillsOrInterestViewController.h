//
//  NakedEditSkillsOrInterestViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEditSkillsOrInterestViewController : UIViewController

@property (nonatomic,strong)NSMutableArray  *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *addTextF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic,strong) void (^editCallBack)(NSString*str);

- (IBAction)addAction:(UIButton *)sender;


@end

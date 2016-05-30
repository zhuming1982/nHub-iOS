//
//  CountryCodeTableViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCodeTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ContryTableview;
@property (nonatomic,strong) NSMutableDictionary *attr;
@property (strong,nonatomic) UISearchController *seachDC;//搜索控制


@property (nonatomic,copy)void (^Country_Back)(NSString* back_str);


@end

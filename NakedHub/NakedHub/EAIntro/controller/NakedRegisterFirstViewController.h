//
//  NakedRegisterFirstViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedRegisterFirstViewController : UITableViewController

@property (nonatomic,strong) NSMutableDictionary *attr;
@property (nonatomic, assign) NSString *country_code_str;
@property (weak, nonatomic) IBOutlet UIButton *Country_btn;

@property (nonatomic,assign) BOOL isTeamCodeLogin;

@end

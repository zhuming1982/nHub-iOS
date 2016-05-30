//
//  NHCompanyDetailsViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHCompanyDetailsViewController : UIViewController
@property (nonatomic,assign) BOOL isMy;

@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic, assign) NSInteger Details_ID;
@property (weak, nonatomic) IBOutlet UILabel *Follower_number;
@property (weak, nonatomic) IBOutlet UIButton *Follow_BTN_outlet;
//header items
@property (weak, nonatomic) IBOutlet UILabel *company_title;
@property (weak, nonatomic) IBOutlet UILabel *Location_label;
@property (weak, nonatomic) IBOutlet UILabel *Followers_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nav_RIGHT_BTN;

//winky

//@property (weak,nonatomic) NSInteger    currentTag;


- (IBAction)Edit_Right_btn:(UIBarButtonItem *)sender;
- (IBAction)Follow_act:(UIButton *)sender;


@property (nonatomic,strong) void (^FollowBack)();
@property (nonatomic,strong) void (^PopBack)();
@property (nonatomic,strong) void (^FollowBOOL)(BOOL followed);
@property (nonatomic,strong) void (^PopName)(NSString * b_name);


@end











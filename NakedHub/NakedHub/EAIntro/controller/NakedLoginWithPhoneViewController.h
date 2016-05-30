//
//  NakedLoginWithPhoneViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedMobileNumberCell.h"

@interface NakedLoginWithPhoneViewController : UIViewController

@property (nonatomic,strong) void (^getCodeViaSms)(NSString *phoneNumber,NSDictionary *dic);

@property (nonatomic,strong) void (^getCountryCode)(NSString *CountryCode);

@property (nonatomic,assign) NSString *country_str;//国家码

@property (nonatomic,strong) NakedMobileNumberCell *numberCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;

@end

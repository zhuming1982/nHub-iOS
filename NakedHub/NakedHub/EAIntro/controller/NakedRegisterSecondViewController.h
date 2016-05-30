//
//  NakedRegisterSecondViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//


typedef NS_ENUM(NSInteger, loginType) {
    login,
    signUp,
    teamLogin
};

#import <UIKit/UIKit.h>

@interface NakedRegisterSecondViewController : UIViewController

@property (nonatomic,strong) NSMutableDictionary *attr;

@property (nonatomic,assign) loginType isLogin;



@end

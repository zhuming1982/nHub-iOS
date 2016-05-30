//
//  NakedLoginWithEmailViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedLoginWithEmailViewController : UIViewController
@property (nonatomic,strong) NSMutableDictionary *attr;

@property (nonatomic,copy) void (^showError)(NSString *msg);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;

@end

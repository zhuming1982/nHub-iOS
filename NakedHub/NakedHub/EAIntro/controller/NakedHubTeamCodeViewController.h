//
//  NakedHubTeamCodeViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedHubTeamCodeViewController : UIViewController

@property (nonatomic,copy) void (^loginCallBack)(id objc,NSString*code);

@property (nonatomic,copy) void (^whatsThis)();
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;


@end

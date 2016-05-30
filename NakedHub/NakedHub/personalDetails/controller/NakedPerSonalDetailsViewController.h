//
//  NakedPerSonalDetailsViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedUserModel.h"

@interface NakedPerSonalDetailsViewController : UIViewController

@property (nonatomic,strong) NakedUserModel *userModel;
@property (nonatomic,assign) BOOL isMy;

@end

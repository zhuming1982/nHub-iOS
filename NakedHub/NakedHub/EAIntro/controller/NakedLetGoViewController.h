//
//  ViewController.h
//  注册－登入－界面
//
//  Created by 施豪 on 16/3/16.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedLetGoViewController : UIViewController

@property (nonatomic,assign) NSInteger orderId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_space;
@property (weak, nonatomic) IBOutlet UIImageView *head_image;

- (IBAction)letgo:(id)sender;

@end


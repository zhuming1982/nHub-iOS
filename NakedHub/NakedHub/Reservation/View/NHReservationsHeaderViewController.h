//
//  NHReservationsHeaderViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHReservationsHeaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerview;

//Head_title nature
-(void)showHead_title:(NSString*)text h_view:(UIView *)h_view;

@end

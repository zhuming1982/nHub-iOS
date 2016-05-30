//
//  NHReservationsHeaderViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHReservationsHeaderViewController.h"

@interface NHReservationsHeaderViewController ()

@end

@implementation NHReservationsHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Head_title nature
-(void)showHead_title:(NSString*)text h_view:(UIView *)h_view
{
    //Now Devices width.Size
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"NHReservations" bundle:nil];
    UIViewController* vc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"NHReservationListViewController"];
    
    UILabel *headlabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 15,vc.view.frame.size.width, 20)];
    headlabel.textAlignment = NSTextAlignmentLeft;
    [headlabel setText:text];
    headlabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    headlabel.textColor =  [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    [h_view addSubview:headlabel];
}

@end

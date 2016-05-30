//
//  MainViewController.h
//  SportSocial
//
//  Created by ZhuMing on 15/10/15.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UITabBarController
{
    EMConnectionState _connectionState;
}


- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
-(void)loadNotificationCenter;



@end

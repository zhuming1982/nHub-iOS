//
//  AppDelegate.h
//  NakedHub
//
//  Created by 朱明 on 16/3/7.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
#import "PushMsgModel.h"
#import "MainViewController.h"
#import "Mixpanel.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    EMConnectionState _connectionState;
    
   
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSArray *HubList;
@property (nonatomic , strong)PushMsgModel    *pushMsgModel;
@property (nonatomic , strong)MainViewController  *mainVC;






@end


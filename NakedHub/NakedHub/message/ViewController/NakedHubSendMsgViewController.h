//
//  NakedHubSendMsgViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubGroupModel.h"

@interface NakedHubSendMsgViewController : UIViewController

@property (nonatomic,strong)void (^sendMsgSuccessCallBack)(id objc);


@end

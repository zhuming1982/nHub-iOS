//
//  NakedHubFeedDetailsViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubFeedModel.h"

@interface NakedHubFeedDetailsViewController : UIViewController

@property (nonatomic,assign) NSInteger feedModelId;

@property (nonatomic,strong) NakedHubFeedModel *feedModel;

@property (nonatomic,copy) void (^likeCallBack)(NakedHubFeedModel *feedModel);

@property (nonatomic,copy) void (^commentsCallBack)(NakedHubFeedModel *feedModel);



- (IBAction)back:(UIBarButtonItem *)sender;

@end

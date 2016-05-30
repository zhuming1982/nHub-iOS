//
//  NakedEventsDetailViewController.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEventsDetailViewController : UIViewController

@property (nonatomic) BOOL isRefresh; /* 用于取消参加活动刷新 Today , RecommendEvents 页面 */
@property (nonatomic, copy) void (^popRecommendBack)();
@property (nonatomic, copy) void (^popBack)(NSInteger modelEventsId);

@property (nonatomic, assign) NSInteger eventsId;

@end

//
//  TodayRecommendEventsViewController.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayRecommendEventsViewController : UIViewController

@property (nonatomic, copy) void (^popTodayBack)(NSMutableArray *recommendEvents);
@property (nonatomic, copy) NSString *queryUnit;

@end

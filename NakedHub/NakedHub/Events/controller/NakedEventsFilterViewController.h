//
//  NakedEventsFilterViewController.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEventsFilterViewController : UIViewController

@property (nonatomic, copy) void (^filterEvents)(NSDictionary *filterDictionary);

@end

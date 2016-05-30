//
//  NakedHubPostFeedViewController.h
//  NakedHub
//
//  Created by 朱明 on 16/3/11.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAutoGrowingTextView.h"

@interface NakedHubPostFeedViewController : UIViewController
@property (nonatomic,copy) void (^pull)();
@property (nonatomic, copy) BOOL (^isPhoto)();

@end

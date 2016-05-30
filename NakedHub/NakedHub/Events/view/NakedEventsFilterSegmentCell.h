//
//  NakedEventsFilterSegmentCell.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEventsFilterSegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *segmentedLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, copy) void (^SelectSegmentedControl)(NSString *region);

@end

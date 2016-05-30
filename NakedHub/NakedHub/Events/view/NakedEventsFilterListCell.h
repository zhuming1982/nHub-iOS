//
//  NakedEventsFilterListCell.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NakedEventsFilterListModel;

@interface NakedEventsFilterListCell : UITableViewCell

@property (nonatomic, strong) NakedEventsFilterListModel *filterListModel;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@end

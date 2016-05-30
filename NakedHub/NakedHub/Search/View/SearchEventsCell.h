//
//  SearchEventsCell.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NakedEventsModel;

@interface SearchEventsCell : UITableViewCell

@property (nonatomic) BOOL isToday; /* NHTodayListTableViewController 页面使用 */
@property (nonatomic, strong) NakedEventsModel *searchEventsModel;

@end

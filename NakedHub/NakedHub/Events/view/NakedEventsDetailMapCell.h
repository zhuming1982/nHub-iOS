//
//  NakedEventsDetailMapCell.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NakedEventsDetailModel;

@interface NakedEventsDetailMapCell : UITableViewCell

@property (nonatomic, strong) NakedEventsDetailModel *eventsDetailModel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;

@end

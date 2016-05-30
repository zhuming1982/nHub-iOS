//
//  NakedEventsDetailAboutCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailAboutCell.h"

#import "NakedEventsDetailModel.h"

@interface NakedEventsDetailAboutCell ()

@property (weak, nonatomic) IBOutlet UILabel *aboutLabel; // 关于

@property (weak, nonatomic) IBOutlet UILabel *aboutDetailLabel; // 关于的详细内容

@end

@implementation NakedEventsDetailAboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEventsDetailModel:(NakedEventsDetailModel *)eventsDetailModel
{
    _eventsDetailModel = eventsDetailModel;
    
    _aboutLabel.text = [GDLocalizableClass getStringForKey:@"About"];
    _aboutDetailLabel.text = _eventsDetailModel.eventsDescription;
    _aboutDetailLabel.numberOfLines = 0;
}

@end

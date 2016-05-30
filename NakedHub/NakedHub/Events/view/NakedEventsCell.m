//
//  NakedEventsCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsCell.h"

#import "NakedEventsModel.h"
#import <QuartzCore/QuartzCore.h>

@interface NakedEventsCell ()

@property (weak, nonatomic) IBOutlet UIView *backGroundShadowView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property (weak, nonatomic) IBOutlet UIImageView *eventsImageView; // 活动图片

@property (weak, nonatomic) IBOutlet UILabel *dateLabel; // 日期

@property (weak, nonatomic) IBOutlet UILabel *eventsLabel; // 活动

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间

@property (weak, nonatomic) IBOutlet UILabel *placeLabel; // 地点

@end

@implementation NakedEventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_backGroundView CornerWithRadius:4.0];
    
    CALayer *layer = [_backGroundShadowView layer];
    layer.shadowOffset = CGSizeMake(0, 0); // 设置偏移量 第一个参数 左右 左负右正 第二个参数 上下 下正上负
    layer.shadowRadius = 4.0; // 阴影半径
    layer.shadowColor = [UIColor grayColor].CGColor; // 阴影颜色
    layer.shadowOpacity = 0.4; // 阴影透明度
}

- (void)setEventsModel:(NakedEventsModel *)eventsModel
{
    _eventsModel = eventsModel;
    [_eventsImageView sd_setImageWithURL:[NSURL URLWithString:_eventsModel.background] placeholderImage:[UIImage imageNamed:@"feedImage"]];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[@(_eventsModel.startTime).stringValue doubleValue] / 1000];
    _dateLabel.text = [Utility get_DDMMYYYY:startDate];

    _eventsLabel.text = _eventsModel.title;
    _eventsLabel.numberOfLines = 0;
    
    //开始－结束 时间点
    NSString *start_hour = [Utility getHourMinuteWithInt:_eventsModel.startTime];
    NSString *end_hour = [Utility getHourMinuteWithInt:_eventsModel.endTime];
    
    NSString *start_end = [NSString stringWithFormat:@"%@ - %@",start_hour,end_hour];
    
    _timeLabel.text = start_end;
    _placeLabel.text = _eventsModel.hub.address;
}

@end

//
//  SearchEventsCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchEventsCell.h"

#import "NakedEventsModel.h"

@interface SearchEventsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *eventsImageView;

@property (weak, nonatomic) IBOutlet UILabel *eventsName;

@property (weak, nonatomic) IBOutlet UILabel *eventsDate;

@property (weak, nonatomic) IBOutlet UILabel *eventsHub;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventsNameTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventsHubHeight;


@end

@implementation SearchEventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [Utility configSubView:_eventsImageView CornerWithRadius:54.0 / 10.f];
//}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    //    //顶部分割线
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
    //底部分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220.0 / 255.0f green:220.0 / 255.0f blue:223.0 / 255.0f alpha:0.5f].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
    
    [Utility configSubView:_eventsImageView CornerWithRadius: _isToday ? 27 : 54.0 / 10.f];
}

- (void)setSearchEventsModel:(NakedEventsModel *)searchEventsModel
{
    _searchEventsModel = searchEventsModel;
    
    [_eventsImageView sd_setImageWithURL:[NSURL URLWithString:_searchEventsModel.background] placeholderImage:[UIImage imageNamed:@"SearchEventsIcon"]];
    
    _eventsName.text = _searchEventsModel.title;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[@(_searchEventsModel.startTime).stringValue doubleValue] / 1000];
    _eventsDate.text = [Utility get_DDMMYYYY:startDate];
    
    if (_searchEventsModel.hub.address == nil) {
        _eventsNameTop.constant = 6;
        _eventsHubHeight.constant = 0;
        
        _eventsHub.text = @"";
    } else {
        _eventsNameTop.constant = -2;
        _eventsHubHeight.constant = 19;
        
        _eventsHub.text = _searchEventsModel.hub.address;
    }
}

@end

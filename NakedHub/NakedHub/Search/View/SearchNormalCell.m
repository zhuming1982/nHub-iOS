//
//  SearchNormalCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchNormalCell.h"

#import "SearchNormalModel.h"

@interface SearchNormalCell ()

@property (weak, nonatomic) IBOutlet UIImageView *normalImageView;

@property (weak, nonatomic) IBOutlet UILabel *normalLabel;

@end

@implementation SearchNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [Utility configSubView:_normalImageView CornerWithRadius:27.0];
}

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
}

- (void)setSearchNormalModel:(SearchNormalModel *)searchNormalModel
{
    _searchNormalModel = searchNormalModel;
    
    [_normalImageView sd_setImageWithURL:[NSURL URLWithString:_searchNormalModel.picture] placeholderImage:[UIImage imageNamed:@"SearchEventsIcon"]];
    
    _normalLabel.text = _searchNormalModel.message;
}

@end

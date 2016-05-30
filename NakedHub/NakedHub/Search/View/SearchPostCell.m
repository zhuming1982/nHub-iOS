//
//  SearchPostCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchPostCell.h"

#import "NakedHubFeedModel.h"

@interface SearchPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@property (weak, nonatomic) IBOutlet UILabel *postContent;

@end

@implementation SearchPostCell

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
    
    [Utility configSubView:_postImageView CornerWithRadius:27.0];
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

- (void)setSearchPostModel:(NakedHubFeedModel *)searchPostModel
{
    _searchPostModel = searchPostModel;
    
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:_searchPostModel.user.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    _postContent.text = _searchPostModel.content;
}

@end

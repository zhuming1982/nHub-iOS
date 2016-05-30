//
//  SearchCompaniesCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchCompaniesCell.h"

#import "NHCompaniesDetailsModel.h"

@interface SearchCompaniesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *companiesImageView;

@property (weak, nonatomic) IBOutlet UILabel *companiesName;

@property (weak, nonatomic) IBOutlet UILabel *companiesHub;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companiesTop;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companiesHubHeight;

@end

@implementation SearchCompaniesCell

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
    
    [Utility configSubView:_companiesImageView CornerWithRadius:54.0 / 10.f];
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

- (void)setSearchCompaniesModel:(NHCompaniesDetailsModel *)searchCompaniesModel
{
    _searchCompaniesModel = searchCompaniesModel;
    
    [_companiesImageView sd_setImageWithURL:[NSURL URLWithString:_searchCompaniesModel.logo] placeholderImage:[UIImage imageNamed:@"CompanyIcon"]];
    
    if (_searchCompaniesModel.hub.name == nil) {
        _companiesTop.constant = 16;
        _companiesHubHeight.constant = 0;
        
        _companiesName.text = _searchCompaniesModel.name;
        _companiesHub.text = @"";
    } else {
        _companiesTop.constant = 8;
        _companiesHubHeight.constant = 19;
        
        _companiesName.text = _searchCompaniesModel.name;
        _companiesHub.text = _searchCompaniesModel.hub.name;
    }
}

@end

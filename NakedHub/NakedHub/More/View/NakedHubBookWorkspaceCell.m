//
//  NakedHubBookWorkspaceCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBookWorkspaceCell.h"

@implementation NakedHubBookWorkspaceCell


- (void) setHubModel:(NakedHubModel *)hubModel
{
    _hubModel = hubModel;
    [_workSpaceImageView sd_setImageWithURL:[NSURL URLWithString:hubModel.picture] placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    _creditsLabel.text = @(hubModel.quotaCost4WorkSpace).stringValue;
    _titleLabel.text = _hubModel.name;
    _addressLabel.text = _hubModel.address;
    _phoneNumberLabel.text = _hubModel.phone;
    _availableLabel.text = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%li AVAILABLE"],(long)_hubModel.remainingTimes];
    
    [self.bookNowBtn setBackgroundColor:_hubModel.remainingTimes?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:212.0/255.0 alpha:1.0]];
    
    self.bookNowBtn.enabled = _hubModel.remainingTimes == 0?NO:YES;
    
    [self.bookNowBtn setTitle:[GDLocalizableClass getStringForKey:@"Book Now"] forState:UIControlStateNormal];
    
//    self.bottomHeightConstraint.constant = _titleLabel.frame.size.height+_addressLabel.frame.size.height+_phoneNumberLabel.frame.size.height+_addressLabel.frame.size.height+31;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    

    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_bookNowBtn CornerWithRadius:_bookNowBtn.frame.size.height/2];
    _workSpaceImageView.layer.masksToBounds = YES;
    UIBezierPath *maskPath_view = [UIBezierPath bezierPathWithRoundedRect:_workSpaceImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer_view = [[CAShapeLayer alloc] init];
    maskLayer_view.frame = _workSpaceImageView.bounds;
    maskLayer_view.path = maskPath_view.CGPath;
    _workSpaceImageView.layer.mask = maskLayer_view;
    
    //image 圆角
    _bottomView.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bottomView.layer.mask = maskLayer;
    
    CALayer *layer = [_bgView layer];
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowRadius = 2.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bookNowAction:(UIButton *)sender {
    [mixPanel track:@"bookWorkSpace_bookNow" properties:logInDic];
    if (_bookNowCallBack) {
        _bookNowCallBack();
    }
}
@end

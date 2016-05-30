//
//  carouselView.m
//  NakedHub
//
//  Created by zhuming on 16/3/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "carouselView.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"

@implementation carouselView

- (id) init {
    id obj = loadObjectFromNib(@"carouselView", [carouselView class], self);
    if (obj) {
        self = (carouselView *)obj;
    } else {
        self = [self init];
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
    _countLabel.layer.masksToBounds = YES;
    _topImageView.layer.masksToBounds = YES;
    _priceF.layer.masksToBounds = YES;
    
//    [_typeLabel setText:[GDLocalizableClass getStringForKey:@"Unlimited  online community"]];
    
    CGFloat viewWidth = [Utility carouselViewHeight];
    CGRect viewFrame = self.frame;
    viewFrame.size = CGSizeMake(232.0*(viewWidth/374.0), viewWidth);
    self.frame = viewFrame;
    if([Utility isiPhone4])
    {
        _countLabel.font = [UIFont fontWithName:@"Avenir Book" size:9];
        _titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:16];
        _daysOrMonthLabel.font = [UIFont fontWithName:@"Avenir Book" size:10];
        _typeLabel.font = [UIFont fontWithName:@"Avenir Book" size:10];
        _priceF.font = [UIFont fontWithName:@"Avenir Book" size:9];
        _reductionBtn.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:11];
        _addBtn.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:11];
        _imageBottomConstraint.constant = 10;
        _typeLabelBottomConstraint.constant = 10;
        _topConstraint.constant = 20.0;
        _topImageView.layer.cornerRadius = 35.5;
        _priceF.layer.cornerRadius = 9.5;
        _countLabel.layer.cornerRadius = 8;
        _topConstraint.constant = 30.0;
    }
    else if([Utility isiPhone5])
    {
        _reductionBtn.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:14];
        _addBtn.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:14];
        _countLabel.font = [UIFont fontWithName:@"Avenir Book" size:11];
        _typeLabel.font = [UIFont fontWithName:@"Avenir Book" size:13];
        _countLabel.layer.cornerRadius = 11.2;
        _topImageView.layer.cornerRadius = 47.5;
        _topConstraint.constant = 30.0;
        _priceF.font = [UIFont fontWithName:@"Avenir Book" size:12];
        _priceF.layer.cornerRadius = 13;
    }
    else if([Utility isiPhone6])
    {
        _countLabel.layer.cornerRadius = _countLabel.frame.size.width/2;
        _topImageView.layer.cornerRadius = _topImageView.frame.size.width/2;
        _priceF.layer.cornerRadius = _priceF.frame.size.height/2;
    }
    else if([Utility isiPhone6p])
    {
        _imageBottomConstraint.constant = 28;
        _typeLabelBottomConstraint.constant = 28;
        _topConstraint.constant = 58.0;
        _countLabel.layer.cornerRadius = 15.8;
        _topImageView.layer.cornerRadius = 70;
        _priceF.layer.cornerRadius = 20;
    }
    return self;
}

-(void) setMemberShipModel:(NakedMemberShipModel *)memberShipModel
{
    _countLabel.text = [NSString stringWithFormat:@"%li",(long)memberShipModel.count];
    _titleLabel.text = memberShipModel.name;
    _daysOrMonthLabel.text = memberShipModel.limitedIntroduction;
    
    NSString  *str = [GDLocalizableClass getStringForKey:@"month"];
    _priceF.text = [NSString stringWithFormat:@"¥%.f／%@",memberShipModel.price,str];
    _typeLabel.text = memberShipModel.quotaPerMonthIntroduction;
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:memberShipModel.picture] placeholderImage:[UIImage imageNamed:@""]];
}

- (IBAction)add:(id)sender {
    [mixPanel track:@"ChooseMembership_add" properties:logOutDic];
    if (_addAndSubtractCallBack) {
        _addAndSubtractCallBack(sender);
    }
}
- (IBAction)reduction:(id)sender {
    [mixPanel track:@"ChooseMembership_minus" properties:logOutDic];
    if (_addAndSubtractCallBack) {
        _addAndSubtractCallBack(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

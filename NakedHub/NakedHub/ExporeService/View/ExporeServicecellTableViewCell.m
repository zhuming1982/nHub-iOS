//
//  v1cell1TableViewCell.m
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import "ExporeServicecellTableViewCell.h"

@implementation ExporeServicecellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.left_iamge.layer.masksToBounds=YES;
    self.left_iamge.layer.cornerRadius=44/10.0f; //设置圆角

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
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height -0.5, rect.size.width, 0.5));

}

//赋值-ExporeServicesModel
-(void)setServicesModel:(ExporeServicesModel *)ServicesModel{
    
    _ServicesModel=ServicesModel;
    self.title_label.text = _ServicesModel.name;
    self.members.text=[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld members"],(long)_ServicesModel.memberCount];
    self.left_iamge.image = [UIImage imageNamed:@"ServicesIcon"];

}
//赋值-NHCompaniesDetailsModel
-(void)setCompaniesDetailsModel:(NHCompaniesDetailsModel *)CompaniesDetailsModel{
    _CompaniesDetailsModel=CompaniesDetailsModel;
    self.title_label.text = _CompaniesDetailsModel.name;
    self.members.text=[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld members"],(long)_CompaniesDetailsModel.memberCount];
    NSURL *Logo_imageUrl = [NSURL URLWithString:_CompaniesDetailsModel.logo];
    [self.left_iamge sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyIcon"]];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

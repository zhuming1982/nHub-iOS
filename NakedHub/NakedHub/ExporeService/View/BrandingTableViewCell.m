//
//  BrandingTableViewCell.m
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import "BrandingTableViewCell.h"

@implementation BrandingTableViewCell
@synthesize Follow_btn;

- (void)awakeFromNib {
    // Initialization code
    self.left_image.layer.masksToBounds=YES;
    self.left_image.layer.cornerRadius=54/10.0f;


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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//赋值-CompaniesDetailsModel
-(void)setCompaniesDetailsModel:(NHCompaniesDetailsModel *)CompaniesDetailsModel{
    _CompaniesDetailsModel=CompaniesDetailsModel;

    self.title_label.text = CompaniesDetailsModel.name;
    self.menber_label.text=[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld members"],(long)CompaniesDetailsModel.memberCount];
    NSURL *Logo_imageUrl = [NSURL URLWithString:CompaniesDetailsModel.logo];
    [self.left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyIcon"]];
   
    if (_CompaniesDetailsModel.followed) {
        [self.Follow_btn setTitle:@"" forState:UIControlStateNormal];
        [self.Follow_btn setBackgroundColor:RGBACOLOR(220,220,223,1.0)];
        [self.Follow_btn setImage:[UIImage imageNamed:@"iconCheck"]
                         forState:UIControlStateNormal];
    }
    else{
        [self.Follow_btn setTitle:[GDLocalizableClass getStringForKey:@"Follow"] forState:UIControlStateNormal];
        [self.Follow_btn setBackgroundColor:[UIColor orangeColor]];
        [self.Follow_btn setImage:nil forState:UIControlStateNormal];
    }
    

    
}
//赋值-ExporeServicesModel
-(void)setServicesModel:(ExporeServicesModel *)ServicesModel{
    _ServicesModel=ServicesModel;
    
    self.title_label.text = _ServicesModel.name;
    self.menber_label.text=[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld members"],(long)_ServicesModel.memberCount];
    self.left_image.image = [UIImage imageNamed:@"ServicesIcon"];
    
}


- (IBAction)Follow_act:(id)sender {
    [mixPanel track:@"Branding_Follow" properties:logInDic];
    if(_buttonActionBlock){
        _buttonActionBlock(sender);
    }
}

@end

//
//  CornerRadiusBorderView.m
//  SportSocial
//
//  Created by wings on 15/11/18.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "CornerRadiusBorderView.h"

@implementation CornerRadiusBorderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.borderWidth = 1;
    self.borderColor = [UIColor whiteColor];
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

@end

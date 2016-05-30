//
//  NakedMobileNumberCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedMobileNumberCell.h"

@implementation NakedMobileNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.mobileNumberTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Mobile Number"]];

}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField.text stringByAppendingString:string].length>20) {
//        textField.text =  [[textField.text stringByAppendingString:string] substringToIndex:20];
//        return NO;
//    }
//    
//    if (range.location>20) {
//        return [string isEqualToString:@""];
//    }
//    return YES;
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

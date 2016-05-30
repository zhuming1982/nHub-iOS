//
//  NakedPersonalDAccountCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPersonalDAccountCell.h"

@implementation NakedPersonalDAccountCell
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField.text stringByAppendingString:string].length>40) {
//        textField.text =  [[textField.text stringByAppendingString:string] substringToIndex:40];
//        return NO;
//    }
//    if (range.location>40) {
//        return [string isEqualToString:@""];
//    }
//    return YES;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.accountContentTextF.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

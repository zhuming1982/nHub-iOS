//
//  NakedPersonalDetailsTextCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPersonalDetailsTextCell.h"

@implementation NakedPersonalDetailsTextCell

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField.text stringByAppendingString:string].length>30) {
//        textField.text =  [[textField.text stringByAppendingString:string] substringToIndex:30];
//        return NO;
//    }
//    if (range.location>30) {
//        return [string isEqualToString:@""];
//    }
//    return YES;
//}


- (void)awakeFromNib {
    [super awakeFromNib];
//    self.contentTextF.delegate = self;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

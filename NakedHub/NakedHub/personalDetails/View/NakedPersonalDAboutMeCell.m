//
//  NakedPersonalDAboutMeCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPersonalDAboutMeCell.h"

@implementation NakedPersonalDAboutMeCell


- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self.whatDoLabel setText:[GDLocalizableClass getStringForKey:@"WHAT WE DO"]];
}

//-(void)textChange:(NSNotification*)not
//{
//    if (self.contentTextV.text.length>160) {
//        self.contentTextV.text =  [self.contentTextV.text  substringToIndex:160];
//        self.textCountLabel.text = [NSString stringWithFormat:@"%lu/160",(unsigned long)self.contentTextV.text.length];
//    }
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    if ([textView.text stringByAppendingString:text].length>160) {
//        textView.text =  [[textView.text stringByAppendingString:text] substringToIndex:160];
//        return NO;
//    }
//    
//    if(self.contentTextV.text.length>=160&&(![text isEqualToString:@""]))
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

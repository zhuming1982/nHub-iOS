//
//  NHComanyEditNameTableViewCell.m
//  NakedHub
//
//  Created by 施豪 on 16/4/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHComanyEditNameTableViewCell.h"

@implementation NHComanyEditNameTableViewCell

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
//}

- (void)awakeFromNib {
    // Initialization code
//    self.company_textView.delegate=self;
////    [self contentSizeToFit];
//    //控制快捷输入
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];

}

//-(void)textChange:(NSNotification*)not
//{
//    if (self.company_textView.text.length>50) {
//        self.company_textView.text =  [self.company_textView.text  substringToIndex:50];
//    }
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    //黏贴长度控制
//    if ([textView.text stringByAppendingString:text].length>50) {
//        textView.text =  [[textView.text stringByAppendingString:text] substringToIndex:50];
//        return NO;
//    }
//    //输入长度控制
//    if(self.company_textView.text.length>=50&&(![text isEqualToString:@""]))
//    {
//        return NO;
//    }
//    
//    return YES;
//
//}




- (void)contentSizeToFit {
    if([_company_textView.text length]>0) {
        CGSize contentSize = _company_textView.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= _company_textView.frame.size.height) {
            CGFloat offsetY = (_company_textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else {
            newSize = _company_textView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 16;
            while (contentSize.height > _company_textView.frame.size.height) {
                [_company_textView setFont:[UIFont fontWithName:@"Avenir-Medium" size:fontSize--]];
                contentSize = _company_textView.contentSize;
            }
            newSize = contentSize;
        }
        [_company_textView setContentSize:newSize];
        [_company_textView setContentInset:offset];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

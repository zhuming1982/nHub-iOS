//
//  NHCompanyContentTableViewCell.h
//  NakedHub
//
//  Created by 施豪 on 16/4/12.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHCompanyContentTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *left_image;
@property (weak, nonatomic) IBOutlet UILabel *content_name_label;
@property (weak, nonatomic) IBOutlet UITextView *contact_textview;

@property (weak, nonatomic) IBOutlet UITextField *contact_text;




@end

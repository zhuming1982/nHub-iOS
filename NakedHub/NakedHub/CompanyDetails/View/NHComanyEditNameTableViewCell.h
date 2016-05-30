//
//  NHComanyEditNameTableViewCell.h
//  NakedHub
//
//  Created by 施豪 on 16/4/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHComanyEditNameTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *company_textView;

@end

//
//  NakedPersonalDAboutMeCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedPersonalDAboutMeCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UILabel *whatDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMelabel;

@end

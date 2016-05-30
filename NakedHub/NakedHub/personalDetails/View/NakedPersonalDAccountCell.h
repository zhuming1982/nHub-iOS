//
//  NakedPersonalDAccountCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedPersonalDAccountCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *accountIconView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountContentTextF;

@end

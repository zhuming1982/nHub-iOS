//
//  NakedMobileNumberCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECustomTextField.h"

@interface NakedMobileNumberCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TECustomTextField *mobileNumberTextF;
@property (weak, nonatomic) IBOutlet UIButton *CountryCode_btn;




@end

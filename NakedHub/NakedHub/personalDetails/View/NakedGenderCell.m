//
//  NakedGenderCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedGenderCell.h"

@implementation NakedGenderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setGender:(NSString *)gender
{
    _gender = gender;
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderMOff"] forState:UIControlStateNormal];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderFOff"] forState:UIControlStateNormal];
    if([_gender isEqualToString:@"NOTSET"])
    {
        
    }
    else if ([_gender isEqualToString:@"MALE"]) {
        [self.manBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderM"] forState:UIControlStateNormal];
    }
    else
    {
        [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderF"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)selectedGender:(UIButton *)sender {
    if(100 == sender.tag) {
        [mixPanel track:@"User_edit_man" properties:logInDic];
    } else {
        [mixPanel track:@"User_edit_women" properties:logInDic];
    }
    
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderMOff"] forState:UIControlStateNormal];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"iconGenderFOff"] forState:UIControlStateNormal];
    [sender setBackgroundImage:sender.tag == 101?[UIImage imageNamed:@"iconGenderF"]:[UIImage imageNamed:@"iconGenderM"] forState:UIControlStateNormal];
    if (_selectedGender) {
        _selectedGender(sender.tag == 100?@"MALE":@"FEMALE");
    }
}
@end

//
//  NakedGenderCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedGenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (nonatomic,strong) NSString *gender;
@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;

@property (nonatomic,copy) void (^selectedGender)(NSString *gender);

- (IBAction)selectedGender:(UIButton *)sender;



@end

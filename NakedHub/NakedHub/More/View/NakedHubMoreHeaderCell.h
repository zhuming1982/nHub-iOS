//
//  NakedHubMoreHeaderCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/25.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedHubMoreHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hubAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookWorkSpaceLabel;

@property (nonatomic,copy) void (^selectLocationCallBack)(UIButton*sender);
- (IBAction)selectLocation:(UIButton *)sender;




@end

//
//  NakedHubMoreHeaderCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/25.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubMoreHeaderCell.h"

@implementation NakedHubMoreHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bookRoomLabel setText:[GDLocalizableClass getStringForKey:@"BOOK ROOM"]];
    [self.bookWorkSpaceLabel setText:[GDLocalizableClass getStringForKey:@"BOOK WORKSPACE"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectLocation:(UIButton *)sender {
    [mixPanel track:@"More_selectLocation" properties:logInDic];
    if (_selectLocationCallBack) {
        _selectLocationCallBack(sender);
    }
}


@end

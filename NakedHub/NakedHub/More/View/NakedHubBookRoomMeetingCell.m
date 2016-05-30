//
//  NakedHubBookRoomMeetingCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBookRoomMeetingCell.h"

@implementation NakedHubBookRoomMeetingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentTextView.rac_textSignal subscribeNext:^(NSString *str) {
        if (str.length>0) {
            self.TextBgLabel.text = @"";
        }
        else
        {
        self.TextBgLabel.text =
            [GDLocalizableClass getStringForKey:@"Type notes..."] ;
            [self.optionalBtn setTitle:[GDLocalizableClass getStringForKey:@"OPTIONAL"] forState:UIControlStateNormal];
            [self.descriptionLabel setText:[GDLocalizableClass getStringForKey:@"You may cancel the reservation 1 hour before your scheduled start time."]];
            [self.meetingTitleLabel setText:[GDLocalizableClass getStringForKey:@"MEETING NOTES"]];
        }
    }];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionalAction:(UIButton *)sender {
}
@end

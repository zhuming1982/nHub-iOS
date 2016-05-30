//
//  NakedHubBookRoomMeetingCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedHubBookRoomMeetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meetingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *TextBgLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *optionalBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)optionalAction:(UIButton *)sender;


@end

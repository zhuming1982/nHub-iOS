//
//  GYChatUrlCell.m
//  SportSocial
//
//  Created by ZhuMing on 15/11/18.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "GYChatReceiverUrlCell.h"
#import "Utility.h"

@implementation GYChatReceiverUrlCell
- (id) init {
    id obj = loadObjectFromNib(@"GYChatReceiverUrlCell", [GYChatReceiverUrlCell class], self);
    if (obj) {
        self = (GYChatReceiverUrlCell *)obj;
    } else {
        self = [self init];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _userAvatarView.layer.cornerRadius = 3.0;
    _messageBgView.image = [[UIImage imageNamed:@"chat_receiver_url_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:27];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)selectEvent:(UITapGestureRecognizer *)sender {
    if (_selectEventDetail) {
        _selectEventDetail(self);
    }
}
@end

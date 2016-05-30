//
//  GYChatSendUrlCell.m
//  SportSocial
//
//  Created by ZhuMing on 15/11/18.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "GYChatSendUrlCell.h"
#import "Utility.h"

@implementation GYChatSendUrlCell

- (id) init {
    id obj = loadObjectFromNib(@"GYChatSendUrlCell", [GYChatSendUrlCell class], self);
    if (obj) {
        self = (GYChatSendUrlCell *)obj;
    } else {
        self = [self init];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _messageBgView.image = [[UIImage imageNamed:@"chat_send_url_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:27];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NakedChatListCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedChatListCell.h"

@implementation NakedChatListCell

- (id) init {
    id obj = loadObjectFromNib(@"NakedChatListCell", [NakedChatListCell class], self);
    if (obj) {
        self = (NakedChatListCell *)obj;
    } else {
        self = [self init];
    }
    [Utility configSubView:_HeadPortraitView CornerWithRadius:_HeadPortraitView.frame.size.height/2];
    [Utility configSubView:_promptPointView CornerWithRadius:_promptPointView.frame.size.height/2];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

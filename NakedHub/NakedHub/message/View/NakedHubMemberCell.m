//
//  NakedHubMemberCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/31.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubMemberCell.h"

@implementation NakedHubMemberCell

- (id) init {
    id obj = loadObjectFromNib(@"NakedHubMemberCell", [NakedHubMemberCell class], self);
    if (obj) {
        self = (NakedHubMemberCell *)obj;
    } else {
        self = [self init];
    }
    [Utility configSubView:_userImageView CornerWithRadius:_userImageView.frame.size.height/2];
    return self;
}



- (void) setUserModel:(NakedUserModel *)userModel
{
    _userModel = userModel;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:userModel.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _userNameLabel.text = userModel.nickname;
    _signLabel.text = userModel.userDescription;
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

//
//  NHFeedLikeCell.m
//  NakedHub
//
//  Created by zhuming on 16/5/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHFeedLikeCell.h"

@implementation NHFeedLikeCell

- (void)setUser:(NakedUserModel *)user
{
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:user.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    _userNameLabel.text = user.nickname;
//    NSString *tempHubName;
//    if (user.company.name) {
//        tempHubName = user.company.name;
        _titleLabel.text = user.company.name;
//    }
//    if (user.hub.name) {
//        tempHubName = [tempHubName stringByAppendingString:[NSString stringWithFormat:@", %@",user.hub.name]];
//    }
    _adressLabel.text = user.hub.name;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_portraitImageView CornerWithRadius:_portraitImageView.frame.size.height/2];
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

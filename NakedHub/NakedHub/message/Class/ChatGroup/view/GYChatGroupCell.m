//
//  GYChatGroupCell.m
//  SportSocial
//
//  Created by ZhuMing on 15/11/11.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "GYChatGroupCell.h"
#import "Utility.h"

@implementation GYChatGroupCell

- (id) init {
    id obj = loadObjectFromNib(@"GYChatGroupCell", [GYChatGroupCell class], self);
    if (obj) {
        self = (GYChatGroupCell *)obj;
    } else {
        self = [self init];
    }
    return self;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.groupAvatarView.chatAvatarDataSource = self;
}

- (void)prepareForReuse {
    [self.groupAvatarView reset];
}

-(void) setGroupModel:(NakedHubGroupModel *)groupModel
{
    _groupModel = groupModel;
    _groupNameLabel.text = groupModel.name;
    [self.groupAvatarView reloadAvatars];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}




#pragma mark - DBChatAvatarViewDataSource

- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    return _groupModel.memberAvatars.count;
}

- (DBChatAvatarState)stateForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
   
    return DBChatAvatarStateOffline;
}

//- (NSURL*)imageUrlForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView
//{
//     GYpictureModel *pic = _groupModel.memberAvatars[avatarIndex];
//    return [NSURL URLWithString:pic.url_280_280];
//}
//- (UIImage *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
//    DBUser *user = _chat.users[avatarIndex];
//    return (user.avatar != nil && [user.avatar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) ? [UIImage imageNamed:user.avatar] : nil;
//}


@end

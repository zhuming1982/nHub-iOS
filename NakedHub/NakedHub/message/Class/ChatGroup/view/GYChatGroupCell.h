//
//  GYChatGroupCell.h
//  SportSocial
//
//  Created by ZhuMing on 15/11/11.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBChatAvatarView.h"
#import "NakedHubGroupModel.h"

@interface GYChatGroupCell : UITableViewCell<DBChatAvatarViewDataSource>


@property (nonatomic,weak) IBOutlet DBChatAvatarView *groupAvatarView;

@property (nonatomic,weak) IBOutlet UILabel *groupNameLabel;


@property (nonatomic,strong) NakedHubGroupModel *groupModel;

@end

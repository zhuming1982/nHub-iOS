//
//  GYGroupModel.h
//  SportSocial
//
//  Created by ZhuMing on 15/11/10.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "Mantle.h"
#import "NakedUserModel.h"


@interface NakedHubGroupModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NakedUserModel    *creator;
//@property (nonatomic,strong) GYextModel     *ext;
@property (nonatomic,copy) NSString         *groupDesc;
@property (nonatomic,copy) NSString         *name;
@property (nonatomic,copy) NSString         *huanxinGroupId;
@property (nonatomic,assign) NSInteger       id;
@property (nonatomic,strong) NSString *logo;

@property (nonatomic,strong) NSArray        *memberAvatars;

@property (nonatomic,strong) NSArray        *members;
@property (nonatomic) BOOL currUserIsMember;



@end

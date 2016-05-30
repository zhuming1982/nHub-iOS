//
//  GYUserModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//
//background = "<null>";
//birthday = "<null>";
//company = "<null>";
//contact = "<null>";
//createTime = "2016-03-22 16:04";
//description = "<null>";
//email = "<null>";
//ext =         {
//};
//floor = "<null>";
//followers = "<null>";
//gender = "<null>";
//hub = "<null>";
//id = 79;
//interests = "<null>";
//isBindIm = 1;
//lastLoginTime = "<null>";
//memberType = "<null>";
//mobile = 13817900209;
//nickname = "<null>";
//portait = "<null>";
//skills = "<null>";
//status = "<null>";
//times = "<null>";int
//title = "<null>";
//type = "<null>";
//updateTime = "2016-03-22 16:04";
//website = "<null>";
//work = "<null>";

#import <Mantle/Mantle.h>
#import "NHCompaniesDetailsModel.h"
#import "NakedContactModel.h"
#import "NakedMemberTypeModel.h"
#import "NakedHubModel.h"



@interface NakedUserModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *background;
@property (nonatomic,assign)long long birthday;
@property (nonatomic,strong)NHCompaniesDetailsModel *company;
@property (nonatomic,strong)NakedContactModel *contact;
@property (nonatomic,assign)long long createTime;
@property (nonatomic,copy)NSString *userDescription;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,assign)NSInteger floor;
@property (nonatomic,assign)NSInteger followers;
@property (nonatomic,assign)NSInteger following;
@property (nonatomic,assign) BOOL followed;

@property (nonatomic,copy)NSString *gender;
@property (nonatomic,strong)NakedHubModel *hub;
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,copy)NSString *interests;
@property (nonatomic,strong)NakedMemberTypeModel *memberType;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *portait;
@property (nonatomic,copy)NSString *skills;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,assign)NSInteger times;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,assign)long long updateTime;
@property (nonatomic,copy)NSString *website;
@property (nonatomic,copy)NSString *work;



@end

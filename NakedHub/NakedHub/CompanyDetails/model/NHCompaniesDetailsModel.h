//
//  NHCompaniesDetailsModel.h
//  NakedHub
//
//  Created by 施豪 on 16/3/31.
//  Copyright © 2016年 zhuming. All rights reserved.
//
/*
result": {
"ext": {},
"id": 151,
"memberCount": 3,
"services":
"name": "Moxtra",
"email": "info-china@moxtra.com",
"phone": "+86 13122329172",
"website": "www.moxtra.com",
"introduction": "Moxtra delivers a mobile-first, embeddable cloud collaboration service that lets people work the way they want to,in real-time or any time.",
"background": "http://naked.img-cn-shanghai.aliyuncs.com/img/o_1ac8iomjaffet7plra4t91731c@!chang",
"logo": "http://naked.img-cn-shanghai.aliyuncs.com/img/o_1ac8i2d6h1igf1hnp1hgd17papkth@!zheng",
"address": "1",
"contact": {
    "facebook": "www.facebook.com/MoxtraHQ/?fref=ts",
    "linkedin": "www.linkedin.com/company/2858507?"
},
"isOwner": false
},
*/
#import <Mantle/Mantle.h>
#import "NakedUserModel.h"
#import "ExporeServicesModel.h"
#import "NakedContactModel.h"
#import "NakedHubModel.h"

@class NakedUserModel;

@interface NHCompaniesDetailsModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString       *address;
@property (nonatomic,copy) NSString        *name;
@property (nonatomic,assign) NSInteger      id;
@property (nonatomic,assign) NSInteger      memberCount;
@property (nonatomic,copy) NSString        *email;
@property (nonatomic,copy) NSString        *phone;
@property (nonatomic,copy) NSString        *website;
@property (nonatomic,copy) NSString        *introduction;
@property (nonatomic,copy) NSString        *logo;
@property (nonatomic,copy) NSString        *background;
@property (nonatomic,copy) NSArray<ExporeServicesModel*>*services;
@property (nonatomic,strong) NSArray<NakedUserModel*>*members;
@property (nonatomic,assign) BOOL           followed;
@property (nonatomic,assign) NSInteger      followers;
@property (nonatomic,assign) BOOL           isOwner;
@property (nonatomic,strong) NakedContactModel  *contact;
@property (nonatomic,strong)NakedHubModel *hub;

@end






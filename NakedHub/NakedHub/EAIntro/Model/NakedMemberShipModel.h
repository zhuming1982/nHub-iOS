//
//  NakedMemberShipModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/21.
//  Copyright © 2016年 zhuming. All rights reserved.
// json
//id = 3;
//membershipType = PERSONAL;
//name = UNLIMITED;
//price = 2100;
//quotaPerMonth = 31;

#import <Mantle/Mantle.h>



@interface NakedMemberShipModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) NSInteger memberShipId;
@property (nonatomic,copy) NSString *membershipType;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) double price;
@property (nonatomic,assign) NSInteger quotaPerMonth;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *limitedIntroduction;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *quotaPerMonthIntroduction;



@end

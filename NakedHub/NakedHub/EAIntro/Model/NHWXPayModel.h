//
//  NHWXPayModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

//appId = wx4e3446d7b2b52017;
//nonceStr = 8ce8b102d40392a688f8c04b3cd6cae0;
//packageValue = "Sign=WXPay";
//partnerId = 1328624401;
//prepayId = wx2016041919342841b6e712d70455412714;
//sign = 22E8CF5316CF6F5BAB3EB0A4C8E5FFDE;
//timeStamp = 1461065668;

@interface NHWXPayModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *nonceStr;
@property (nonatomic,copy) NSString *packageValue;
@property (nonatomic,copy) NSString *partnerId;
@property (nonatomic,copy) NSString *prepayId;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *timeStamp;



@end

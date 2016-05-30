//
//  NakedContactModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NakedContactModel : MTLModel<MTLJSONSerializing>


@property (nonatomic,copy) NSString *facebook;
@property (nonatomic,copy) NSString *instagram;
@property (nonatomic,copy) NSString *linkedin;
@property (nonatomic,copy) NSString *twitter;
@property (nonatomic,copy) NSString *wechat;


@end

//
//  APIModel.h
//  NakedHub
//
//  Created by zhuming on 16/4/28.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface APIModel : MTLModel<MTLJSONSerializing>

@property (nonatomic) NSString *version;
@property (nonatomic) NSString *env;

@end

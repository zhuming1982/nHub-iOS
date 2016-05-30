//
//  SearchNormalModel.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/20.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SearchNormalModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *type;

@end

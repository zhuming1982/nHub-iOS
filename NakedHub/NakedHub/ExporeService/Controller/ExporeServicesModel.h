//
//  ExporeServicesModel.h
//  NakedHub
//
//  Created by 施豪 on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ExporeServicesModel : MTLModel<MTLJSONSerializing>

//社区首页 Services
@property (nonatomic,copy) NSString        *name;
@property (nonatomic,assign) NSInteger      id;
@property (nonatomic,assign) NSInteger      memberCount;


@end

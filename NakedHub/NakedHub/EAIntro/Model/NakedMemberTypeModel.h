//
//  NakedMemberTypeModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NakedMemberTypeModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy)NSString    *cnName;
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,copy)NSString    *name;
@property (nonatomic,assign) NSInteger version;



@end

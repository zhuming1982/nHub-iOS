//
//  NHMeetingRoomModel.h
//  NakedHub
//
//  Created by 施豪 on 16/4/27.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NHMeetingRoomModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) NSInteger       id;
@property (nonatomic,copy) NSString   *picture;
@property (nonatomic,copy) NSString   *name;

@end

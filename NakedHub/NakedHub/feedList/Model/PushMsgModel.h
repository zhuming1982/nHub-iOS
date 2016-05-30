//
//  PushMsgModel.h
//  NakedHub
//
//  Created by Winky on 16/4/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PushMsgModel : MTLModel<MTLJSONSerializing>

//@property (nonatomic, retain) NSDictionary*   aps;
@property (nonatomic, copy) NSString       *pushSign;
@property (nonatomic, assign) NSInteger    skipModelId;
@property (nonatomic, assign)NSInteger      id;
@property (nonatomic, assign)NSInteger       refId;
@property (nonatomic,assign) BOOL            skip;


@end

//
//  NakedHubCommentsModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NakedUserModel.h"

@interface NakedHubCommentsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) NSInteger       commentsId;
@property (nonatomic,copy) NSString         *content;
@property (nonatomic,strong) NakedUserModel *user;
@property (nonatomic,assign) BOOL            liked;
@property (nonatomic,strong) NSString *postTime;
@property (nonatomic,assign) NSInteger likeNum;


@end

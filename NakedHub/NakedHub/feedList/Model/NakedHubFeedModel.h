//
//  NakedHubFeedModel.h
//  NakedHub
//
//  Created by zhuming on 16/3/23.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NakedHubCommentsModel.h"

@interface NakedHubFeedModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString         *content;
@property (nonatomic,assign)NSInteger       feedId;
@property (nonatomic,assign) BOOL           liked;
@property (nonatomic,assign) NSInteger      likeNum;
@property (nonatomic,assign) BOOL           commented;
@property (nonatomic,assign) NSInteger      commentNum;
@property (nonatomic,copy)NSString         *postTime;
@property (nonatomic,copy) NSString        *pictureAccessPath;
@property (nonatomic,strong)NakedUserModel *user;
@property (nonatomic,strong)NSMutableArray *comments;
@property (nonatomic,strong)NSMutableArray *likers;

@end

//
//  NHNotificationsModel.h
//  NakedHub
//
//  Created by 施豪 on 16/4/13.
//  Copyright © 2016年 zhuming. All rights reserved.
//
/*
 pushMessages =         (
 {
 body = "nujian\U8d5e\U4e86\U7684feed";
 id = 172249;
 postTime = "4 hours ago";
 pushSign = "FEED_LIKE";
 refId = 172248;
 showPicture = "http://nakedhubappdev.img-cn-shanghai.aliyuncs.com/a3d66454-91bd-49bd-9b46-f955b30c8921.jpg";
 skipModelClass = "com.livenaked.hub.models.Feed_$$_jvst28b_19";
 skipModelId = 172221;
 type = PUSH;
 }
 */

#import <Mantle/Mantle.h>

@interface NHNotificationsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)   NSString        *body;
@property (nonatomic,assign) NSInteger       id;
@property (nonatomic,copy)   NSString        *postTime;
@property (nonatomic,copy)   NSString        *pushSign;
@property (nonatomic,assign) NSInteger       refId;
@property (nonatomic,copy)   NSString        *showPicture;//图片
@property (nonatomic,copy)   NSString        *skipModelClass;
@property (nonatomic,assign) NSInteger       skipModelId;
@property (nonatomic,copy)   NSString        *type;
@property (nonatomic,assign) BOOL            read;
@property (nonatomic,assign) BOOL            skip;


@end










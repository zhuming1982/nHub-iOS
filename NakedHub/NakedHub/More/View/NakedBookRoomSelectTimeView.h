//
//  NakedBookRoomSelectTimeView.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedPullImageView.h"

@interface NakedBookRoomSelectTimeView : UIView

@property(nonatomic,assign)CGPoint oldPoint;
@property(nonatomic,assign)BOOL isMove;
@property(nonatomic,strong)CABasicAnimation *shake;
@property(nonatomic,assign)CGPoint offset;

@property (nonatomic,assign)CGFloat maxWidth;

@property (nonatomic,assign) CGRect oldRect;
@property(nonatomic,strong) NakedPullImageView *pullView;


@property (nonatomic,copy) void (^TouchBegin)(UITouch *aTouch);
@property (nonatomic,copy) void (^TouchMove)(UITouch *aTouch);
@property (nonatomic,copy) void (^TouchEnd)(UITouch *aTouch);

@property (nonatomic,copy) void (^scalingMove)();

@property (nonatomic,copy) void (^scalingEnd)();


@end

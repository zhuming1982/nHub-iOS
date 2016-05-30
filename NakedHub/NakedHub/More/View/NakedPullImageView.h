//
//  NakedPullImageView.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedPullImageView : UIImageView

@property(nonatomic,assign)CGPoint oldPoint;
@property(nonatomic,assign)BOOL isMove;
@property(nonatomic,strong)CABasicAnimation *shake;
@property(nonatomic,assign)CGPoint offset;

@property (nonatomic,copy) void (^TouchBegin)(UITouch *aTouch);
@property (nonatomic,copy) void (^TouchMove)(UITouch *aTouch);
@property (nonatomic,copy) void (^TouchEnd)(UITouch *aTouch);

@end

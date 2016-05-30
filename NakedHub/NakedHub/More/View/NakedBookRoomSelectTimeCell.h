//
//  NakedBookRoomSelectTimeCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedBookRoomSelectTimeView.h"
#import "NakedBookRoomModel.h"

@interface NakedBookRoomSelectTimeCell : UITableViewCell<UICollectionViewDelegate>

@property (nonatomic,strong) NakedBookRoomModel *bookRoomModel;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
- (IBAction)changeTime:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReductionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) NakedBookRoomSelectTimeView *selectTV;
@property (nonatomic,strong) NakedPullImageView *pullView;
@property (nonatomic,assign) CGFloat oldContentOffSet;

@property (nonatomic,assign) BOOL isMoved;

@property (nonatomic,assign) BOOL isZoom;


@property (nonatomic,copy) NSString *selectTVRectStr;

@property (nonatomic,copy) void (^beginCallBack)();
@property (nonatomic,copy) void (^endCallBack)();



@property (nonatomic,copy) void (^ScalingBeginCallBack)();
@property (nonatomic,copy) void (^ScalingEndCallBack)();

@property (nonatomic,copy) void (^changeTVFrame)(BOOL isAllowBook);


@property (nonatomic,strong) NSMutableArray *cellRects;



@end

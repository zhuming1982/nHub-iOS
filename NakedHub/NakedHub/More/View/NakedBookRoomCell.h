//
//  NakedBookRoomCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedBookRoomModel.h"

@interface NakedBookRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *RoomImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel     *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgShadowView;
@property (weak, nonatomic) IBOutlet UIButton    *membersBtn;
@property (weak, nonatomic) IBOutlet UIButton    *FloorBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (nonatomic,strong) NakedBookRoomModel *roomModel;


@property (nonatomic,copy) void (^scorllViewCallBack)(CGPoint offset);

@end

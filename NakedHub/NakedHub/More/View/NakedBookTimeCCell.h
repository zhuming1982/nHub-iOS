//
//  NakedBookTimeCCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubReservationTimeUnitesModel.h"

@interface NakedBookTimeCCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *longLine;
@property (weak, nonatomic) IBOutlet UIView *shortLine;
@property (weak, nonatomic) IBOutlet UIView *figureView;
@property (nonatomic,strong) NakedHubReservationTimeUnitesModel *model;
@property (nonatomic,strong) NakedHubReservationTimeUnitesModel *halfModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


- (void) setModel:(NakedHubReservationTimeUnitesModel *)model
     andHalfModel:(NakedHubReservationTimeUnitesModel *)halfModel;
@end

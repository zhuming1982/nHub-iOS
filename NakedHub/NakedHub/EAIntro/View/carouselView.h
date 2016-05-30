//
//  carouselView.h
//  NakedHub
//
//  Created by zhuming on 16/3/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedMemberShipModel.h"

@interface carouselView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysOrMonthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceF;
@property (weak, nonatomic) IBOutlet UIButton *reductionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabelBottomConstraint;

@property (nonatomic,strong) NakedMemberShipModel *memberShipModel;

@property (nonatomic,copy) void (^addAndSubtractCallBack)(UIButton*sender);


@end

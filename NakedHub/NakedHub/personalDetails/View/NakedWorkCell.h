//
//  NakedWorkCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHCompaniesDetailsModel.h"

@interface NakedWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *workImageView;
@property (weak, nonatomic) IBOutlet UILabel     *workNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *membersCountLabel;

@property (nonatomic,strong) NSArray<UIImageView*>            *memberPortraits;

@property (weak, nonatomic) IBOutlet UIImageView *memberPortrait1;
@property (weak, nonatomic) IBOutlet UIImageView *memberPortrait2;
@property (weak, nonatomic) IBOutlet UIImageView *memberPortrait3;
@property (weak, nonatomic) IBOutlet UIImageView *memberPortrait4;
@property (weak, nonatomic) IBOutlet UIButton    *moreBtn;
@property (nonatomic,copy) void (^selectMoreMember)();
@property (nonatomic,strong)NHCompaniesDetailsModel *companiesDM;

- (IBAction)moreAction:(UIButton *)sender;

@end

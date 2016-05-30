//
//  NakedPerSonalTagListCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NakedPerSonalTagListCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,assign) BOOL isSkills;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) void (^editCallBack)();

@property (weak, nonatomic) IBOutlet UIButton *separateBtn;
@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;
@property (weak, nonatomic) IBOutlet UIButton *addServicesBtn;


- (IBAction)editAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wdithConstraint;


@end

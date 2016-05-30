//
//  NakedEventsDetailInfoCell.h
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NakedEventsDetailModel;
@class NakedEventsAttendeesModel;

@interface NakedEventsDetailInfoCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NakedEventsDetailModel *eventsDetailModel;

@property (nonatomic, strong) NSArray<NakedEventsAttendeesModel *> *attendeesList; // 参与者列表


@end

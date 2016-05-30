//
//  NakedBookWorkSpaceMapCell.h
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubModel.h"


@interface NakedBookWorkSpaceMapCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel   *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel   *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel   *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel   *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel   *messageLabel;
@property (nonatomic,strong)NakedHubModel *hubModel;


@end

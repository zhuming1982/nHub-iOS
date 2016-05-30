//
//  v1cell1TableViewCell.h
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExporeServicesModel.h"
#import "NHCompaniesDetailsModel.h"

@interface ExporeServicecellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *left_iamge;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *members;
@property (nonatomic,strong) ExporeServicesModel *ServicesModel;
@property (nonatomic,strong) NHCompaniesDetailsModel *CompaniesDetailsModel;

@end

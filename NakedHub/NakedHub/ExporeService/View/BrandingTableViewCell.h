//
//  BrandingTableViewCell.h
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHCompaniesDetailsModel.h"
#import "ExporeServicesModel.h"

@interface BrandingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *left_image;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *menber_label;
@property (nonatomic,assign) BOOL isFollow;
@property (weak, nonatomic) IBOutlet UIButton *Follow_btn;
@property (nonatomic,strong) NHCompaniesDetailsModel *CompaniesDetailsModel;
@property (nonatomic,strong) ExporeServicesModel *ServicesModel;




@property (nonatomic,copy)void (^buttonActionBlock)(UIButton *btn);
- (IBAction)Follow_act:(id)sender;


@end

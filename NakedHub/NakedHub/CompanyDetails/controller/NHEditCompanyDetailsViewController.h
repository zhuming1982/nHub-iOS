//
//  NHEditCompanyDetailsViewController.h
//  NakedHub
//
//  Created by 施豪 on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"
#import "NHCompaniesDetailsModel.h"
#import "TSMessage.h"


@interface NHEditCompanyDetailsViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL isMy;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong) void (^updateCallBack)();
@property (nonatomic,strong) NHCompaniesDetailsModel *CompanyModel;

- (IBAction)Save_btn:(UIButton *)sender;



@end

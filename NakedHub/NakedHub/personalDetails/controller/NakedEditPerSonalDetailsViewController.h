//
//  NakedEditPerSonalDetailsViewController.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedUserModel.h"
#import "TPKeyboardAvoidingTableView.h"

@interface NakedEditPerSonalDetailsViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) void (^updateCallBack)();

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong) NakedUserModel *userModel;

@property (nonatomic,assign) BOOL isSign;

@end

//
//  ViewController.m
//  注册－登入－界面
//
//  Created by 施豪 on 16/3/16.
//  Copyright © 2016年 施豪. All rights reserved.
//



#import "NakedLetGoViewController.h"
#import "Constant.h"
#import "Utility.h"
#import "HttpRequest.h"
#import "LocationManager.h"
#import "NakedEditPerSonalDetailsViewController.h"

@interface NakedLetGoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paySuccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *paySucDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *letGoBttn;

@end

@implementation NakedLetGoViewController
@synthesize top_space,head_image;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.paySuccessLabel setText:[GDLocalizableClass getStringForKey:@"Payment Successful!"]];
    [self.paySucDetailLabel setText:[GDLocalizableClass getStringForKey:@"Thank you for your payment. Welcome to the naked Hub community! You are now a Hubber!"]];
    [self.letGoBttn setTitle:[GDLocalizableClass getStringForKey:@"MAKE MY PROFILE"]forState:UIControlStateNormal];
    self.head_image.image=[UIImage imageNamed:@"memberTier1"];
    
    if([Utility isiPhone4]){
        top_space.constant=75;
    }else{
        top_space.constant=150;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
 
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letgo:(id)sender {
    
    [mixPanel track:@"PaySuccess_login" properties:logOutDic];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"orderId":@(_orderId),@"deviceToken":[[NSUserDefaults standardUserDefaults]objectForKey:kDeviceTokenName]?[[NSUserDefaults standardUserDefaults]objectForKey:kDeviceTokenName]:@"",@"UDID":[[NSUserDefaults standardUserDefaults]objectForKey:kUDIDName]}];
        if ([[LocationManager shared] hasGpsRight]) {
            [dic setObject:@(userlongitude) forKey:@"longitude"];
            [dic setObject:@(userLatitude) forKey:@"latitude"];
        }
    [HttpRequest postWithURLSession:auth_reg andViewContoller:self andHudMsg:@"" andAttributes:dic andBlock:^(id response, NSError *error) {
        if (!error) {
            NakedUserModel *model = [MTLJSONAdapter modelOfClass:[NakedUserModel class] fromJSONDictionary:response[@"result"] error:nil];
            
            [[NSUserDefaults standardUserDefaults]setObject:@(model.userId) forKey:kUserIdName];
            [[NSUserDefaults standardUserDefaults]setObject:model.nickname?model.nickname:@"" forKey:kUserName];
            [[NSUserDefaults standardUserDefaults]setObject:model.portait?model.portait:@"" forKey:kUserAvatarUrl];
            
            if (model.hub) {
                [[NSUserDefaults standardUserDefaults]setObject:@(model.hub.hubId) forKey:@"hubID"];
                [[NSUserDefaults standardUserDefaults]setObject:model.hub.address forKey:@"hubaddress"];
                [[NSUserDefaults standardUserDefaults]setObject:model.hub.name forKey:@"hubname"];
                [[NSUserDefaults standardUserDefaults]setObject:model.hub.picture forKey:@"hubpicture"];
            }
            if (model.company) {
                [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"isCompany"];
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            NakedEditPerSonalDetailsViewController *EditPerSonalDetailsVC = (NakedEditPerSonalDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedEditPerSonalDetailsViewController" andParent:self];
            EditPerSonalDetailsVC.userModel = model;
            EditPerSonalDetailsVC.isSign = YES;
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
    
    
}

@end

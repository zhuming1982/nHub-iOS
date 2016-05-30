//
//  NakedHubLoginViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubLoginViewController.h"
#import "NakedLoginWithPhoneViewController.h"
#import "NakedLoginWithEmailViewController.h"
#import "NakedRegisterSecondViewController.h"
#import "NakedHubTeamCodeViewController.h"
#import "CountryCodeTableViewController.h"
#import "NakedMobileNumberCell.h"
#import "Utility.h"
#import "NakedRegisterFirstViewController.h"
#import "NakedHubBenifitViewController.h"


@interface NakedHubLoginViewController ()<NakedHubSlidingControllerDataSource,NakedHubSlidingControllerDelegate>
@property (nonatomic, strong)NSArray *controllers;
@property (nonatomic, strong)NSArray *titles;

@end

@implementation NakedHubLoginViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showError:(NSNotification*)not
{
    
}
//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showError:) name:@"LoginError" object:nil];
    
    self.title = [GDLocalizableClass getStringForKey:@"Login"];

    self.datasouce = self;
    self.delegate = self;
    
    NakedLoginWithPhoneViewController *LoginWithPhoneVC = [Utility GetViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedLoginWithPhoneViewController"];
    
    [LoginWithPhoneVC setGetCodeViaSms:^(NSString *phoneNumber,NSDictionary *respa) {
        
        if ([respa[@"code"]integerValue]==200)
        {
            NakedRegisterSecondViewController *RegisterSecondVC = (NakedRegisterSecondViewController *)[Utility pushViewControllerWithStoryboard:@"EAIntro"  andViewController:@"NakedRegisterSecondViewController" andParent:self];
            RegisterSecondVC.isLogin = login;
            RegisterSecondVC.attr = [NSMutableDictionary dictionaryWithDictionary:@{@"u":phoneNumber}];
        }
        else{
            
            [Utility showErrorWithVC:self andMessage:respa[@"msg"]];
        }
        
    }];
    @weakify(self)
    @weakify(LoginWithPhoneVC)
    [LoginWithPhoneVC setGetCountryCode:^(NSString *CountryCode) {
        @strongify(self)
        
        CountryCodeTableViewController *CountryCode_VC = [Utility GetViewControllerWithStoryboard:@"CountryCode" andViewController:@"CountryCode"];
        
        [CountryCode_VC setCountry_Back:^(NSString *BacK) {
          @strongify(LoginWithPhoneVC)
           LoginWithPhoneVC.country_str=BacK;
           [LoginWithPhoneVC.numberCell.CountryCode_btn setTitle:[NSString stringWithFormat:@"+%@",BacK] forState:UIControlStateNormal];
        }];
        [self.navigationController pushViewController:CountryCode_VC animated:YES];
    }];    
    NakedLoginWithEmailViewController *LoginWithEmailVC = [[UIStoryboard storyboardWithName:@"EAIntro" bundle:nil] instantiateViewControllerWithIdentifier:@"NakedLoginWithEmailViewController"];
    [LoginWithEmailVC setShowError:^(NSString *msg) {
        [Utility showErrorWithVC:self andMessage:msg];
    }];
    NakedHubTeamCodeViewController *TeamCodeVC = [[UIStoryboard storyboardWithName:@"EAIntro" bundle:nil] instantiateViewControllerWithIdentifier:@"NakedHubTeamCodeViewController"];
    [TeamCodeVC setWhatsThis:^{
        NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
        benifitVC.fromPageType = FromWhatDescription;
        
        [mixPanel track:@"Login_teamCode_whatIsThis" properties:logOutDic];
    }];
    [TeamCodeVC setLoginCallBack:^(id objc,NSString *code) {
        if (objc[@"result"]) {
            if ([objc[@"result"] boolValue]) {
                NakedRegisterFirstViewController*RegisterFirstVC = (NakedRegisterFirstViewController*)[Utility pushViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedRegisterFirstViewController" andParent:self];
                RegisterFirstVC.attr = [NSMutableDictionary dictionaryWithDictionary:@{@"teamCode":code}];
                RegisterFirstVC.isTeamCodeLogin = YES;
            }
        }
        else
        {
            [Utility showErrorWithVC:self andMessage:objc[@"msg"]];
        }
    }];
    
    self.titles      = @[[GDLocalizableClass getStringForKey:@"PHONE"] ,
                         [GDLocalizableClass getStringForKey:@"EMAIL"],
                         [GDLocalizableClass getStringForKey:@"TEAM CODE"]];
    self.controllers = @[LoginWithPhoneVC,LoginWithEmailVC,TeamCodeVC];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark dataSouce
- (NSInteger)numberOfPageInFJSlidingController:(NakedHubSlidingController *)fjSlidingController{
    
    return self.titles.count;
}
- (UIViewController *)fjSlidingController:(NakedHubSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index{
    
    return self.controllers[index];
}
- (NSString *)fjSlidingController:(NakedHubSlidingController *)fjSlidingController titleAtIndex:(NSInteger)index{
    
    return self.titles[index];
}
/*
 - (UIColor *)titleNomalColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (UIColor *)titleSelectedColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (UIColor *)lineColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (CGFloat)titleFontInFJSlidingController:(FJSlidingController *)fjSlidingController;
 */

#pragma mark delegate
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedIndex:(NSInteger)index{
    // presentIndex
    NSLog(@"%ld",index);
    //    self.title = [self.titles objectAtIndex:index];
}
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedController:(UIViewController *)controller{
    // presentController
}
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedTitle:(NSString *)title{
    // presentTitle
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

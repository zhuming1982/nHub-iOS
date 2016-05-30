//
//  NakedMoreViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/26.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedMoreViewController.h"
#import "NakedHubMoreCell.h"
#import "NakedHubMoreHeaderCell.h"
#import "NakedPerSonalTableHeadSecionView.h"
#import "NakedPerSonalDetailsViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "NakedHubSelectViewController.h"
#import "NakedHubAccountViewController.h"
#import "NakedHubBenifitViewController.h"
#import "NakedHubAboutDetailTableViewController.h"
#import "NHReservationListViewController.h"

#import "NakedEventsViewController.h"


@interface NakedMoreViewController ()<UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *images;

@property (nonatomic,strong) NakedHubModel *hubModel;


@end

@implementation NakedMoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isCompany"]boolValue]) {
        _titles = @[@[  [GDLocalizableClass getStringForKey:@"SUPPORT"],
                        [GDLocalizableClass getStringForKey:@"UPCOMING RESERVATIONS" ],
                        [GDLocalizableClass getStringForKey:@"GUIDE"],
                        [GDLocalizableClass getStringForKey:@"BENEFITS"],
                        [GDLocalizableClass getStringForKey:@"EVENTS"]],
                    
                    @[ [GDLocalizableClass getStringForKey:@"MY PROFILE"],
                       [ GDLocalizableClass getStringForKey:@"COMPANY PROFILE"],
                       [ GDLocalizableClass getStringForKey:@"ACCOUNT"]],
                    
                    @[
                        [ GDLocalizableClass getStringForKey:@"LANGUAGE"],
                        [ GDLocalizableClass getStringForKey:@"ABOUT"],
                        [ GDLocalizableClass getStringForKey:@"LOGOUT"]]];
        
        _images = @[@[@"moresupport",@"moreUncoming",@"moreguide",@"morebenefits",@"moreevents",@"HONESTY MARKET"],
                    @[@"moreprofile",@"morecompany",@"moreaccount"],
                    @[/*@"moresupport",*/@"morelanguage",@"moreabout",@"morelogout"]];
    }
    else
    {
        _titles = @[@[  [GDLocalizableClass getStringForKey:@"SUPPORT"],
                        [GDLocalizableClass getStringForKey:@"UPCOMING RESERVATIONS" ],
                        [GDLocalizableClass getStringForKey:@"GUIDE"],
                        [GDLocalizableClass getStringForKey:@"BENEFITS"],
                        [GDLocalizableClass getStringForKey:@"EVENTS"]],
                    
                    @[ [GDLocalizableClass getStringForKey:@"MY PROFILE"],
                       /*[ GDLocalizableClass getStringForKey:@"COMPANY PROFILE"],*/
                       [ GDLocalizableClass getStringForKey:@"ACCOUNT"]],
                    
                    @[
                        [ GDLocalizableClass getStringForKey:@"LANGUAGE"],
                        [ GDLocalizableClass getStringForKey:@"ABOUT"],
                        [ GDLocalizableClass getStringForKey:@"LOGOUT"]]];
        
        _images = @[@[@"moresupport",@"moreUncoming",@"moreguide",@"morebenefits",@"moreevents",@"HONESTY MARKET"],
                    @[@"moreprofile"/*,@"morecompany"*/,@"moreaccount"],
                    @[/*@"moresupport",*/@"morelanguage",@"moreabout",@"morelogout"]];
    }
   
    
    
    
    self.tableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]) {
        _hubModel = [[NakedHubModel alloc]init];
        _hubModel.hubId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"] integerValue];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubaddress"]) {
        _hubModel.address = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubaddress"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubname"]) {
        _hubModel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubname"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubpicture"]) {
        _hubModel.picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubpicture"];
    }
    
    NakedHubMoreHeaderCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (_hubModel) {
        cell.hubNameLabel.text = _hubModel.name;
        cell.hubAddressLabel.text = _hubModel.address;
    }
    else{
        
        cell.hubNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        cell.hubAddressLabel.text = [GDLocalizableClass getStringForKey:@"PLEASE SELECT LOCATION"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 2;
        }
            break;
        case 1:
        {
            return 6;
        }
            break;
        case 2:
        {
            return [[[NSUserDefaults standardUserDefaults]objectForKey:@"isCompany"]boolValue]?4:3;
        }
            break;
        case 3:
        {
            return 4;
        }
            break;
        default:
            return 2;
            break;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 1)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 5)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isCompany"]boolValue]?3:2))
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 3:
        {
            if (indexPath.row == 3)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        default:
            break;
    }

    if (indexPath.section==0) {
        
        NakedHubMoreHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubMoreHeaderCell" forIndexPath:indexPath];
        
        @weakify(cell)
        @weakify(self)
        
        [cell setSelectLocationCallBack:^(UIButton *sender) {
            @strongify(cell)
            @strongify(self)
            NakedHubSelectViewController *SelectViewController = (NakedHubSelectViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedHubSelectViewController" andParent:self];
            
            SelectViewController.selectModel = _hubModel;
            [SelectViewController setSelectHubCallBack:^(NakedHubModel *hubModel) {
                if (hubModel) {
                    cell.hubNameLabel.text = hubModel.name;
                    cell.hubAddressLabel.text = hubModel.address;
                    self.hubModel = hubModel;
                }
            }];
        }];
        if (_hubModel) {
            cell.hubNameLabel.text = _hubModel.name;
            cell.hubAddressLabel.text = _hubModel.address;
        }
        else
        {            
            cell.hubNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            cell.hubAddressLabel.text = [GDLocalizableClass getStringForKey:@"PLEASE SELECT LOCATION"];
        }
        return cell;
    }
    else {
        NakedHubMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubMoreCell" forIndexPath:indexPath];
        cell.subTitleLabel.text = nil;
        cell.numBadge.badgeText = nil;

        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.subTitleLabel.text = @"中文 & English";
            }
        }
        cell.iconView.image = [UIImage imageNamed:_images[indexPath.section-1][indexPath.row]];
        cell.titleLabel.text = _titles[indexPath.section-1][indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (indexPath.row==0) {
                //                [Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationListViewController" andParent:self];
                [mixPanel track:@"More_upcomingReservations" properties:logInDic];
                NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
                benifitVC.fromPageType = FromSupport;
                
            }
            else if (indexPath.row==1) {
//                [Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationListViewController" andParent:self];
                [mixPanel track:@"More_upcomingReservations" properties:logInDic];
             NHReservationListViewController* NHReservations = (NHReservationListViewController*)[Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationListViewController" andParent:self];
                 NHReservations.is_more = YES;
            }
            else if (indexPath.row == 2){
                // GUIDE
               
                [mixPanel track:@"More_Guide" properties:logInDic];
                NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
                benifitVC.fromPageType = FromGuide;
                
            }
            else if (indexPath.row == 3){
                
//               benefit
                [mixPanel track:@"More_Benefits" properties:logInDic];
               NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
                benifitVC.fromPageType = FromBenifit;
                
            }
            else if (indexPath.row == 4){
                
                //               Events
                [mixPanel track:@"More_Events" properties:logInDic];
                [Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsViewController" andParent:self];
//                NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
//                benifitVC.fromPageType = FromEvents;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //my profile
                    [mixPanel track:@"More_myProfile" properties:logInDic];
                NakedPerSonalDetailsViewController*perSonalDVC = (NakedPerSonalDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:self];
                    
                    perSonalDVC.isMy = YES;
                }
                    break;
                case 1:
                {
//                    company
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isCompany"]boolValue]) {
                        NHCompanyDetailsViewController* company = (NHCompanyDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self];
                        company.isMy = YES;
                        
                        [mixPanel track:@"More_companyProfile" properties:logInDic];
                    }
                    else
                    {
                        [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubAccountViewController" andParent:self];
                        [mixPanel track:@"More_Account" properties:logInDic];
                    }
                    
                }
                    break;
                case 2:
                {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isCompany"]boolValue]) {
                        [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubAccountViewController" andParent:self];
                        [mixPanel track:@"More_Account" properties:logInDic];
                    }
                }
                    break;
                default:
                {
                    

                }
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self alertViewWithTitle:[GDLocalizableClass getStringForKey:@"Please Select Language"]
                        chBtnTitle:@"中文"
                                  enBtnTitle:@"English"
                     cancleBtnTitle:[GDLocalizableClass getStringForKey:@"Cancel"]];
                    [mixPanel track:@"More_Language" properties:logInDic];
                }
                    break;
                case 1:
                {
                    [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubAboutDetailTableViewController" andParent:self];
                    
                    [mixPanel track:@"More_About" properties:logInDic];

                }
                    break;
                case 2:
                {
                    //退出登录
                    [mixPanel track:@"More_logOut" properties:logInDic];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[GDLocalizableClass getStringForKey:@"Log out"]
                                        message:[GDLocalizableClass getStringForKey:@"Are you sure you want to log out?"]
                                                delegate:self
                                                             cancelButtonTitle:[GDLocalizableClass getStringForKey:@"NO"]
                                                             otherButtonTitles:[GDLocalizableClass getStringForKey:@"YES"], nil];
                    [alertView show];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [Utility logOutWithVC:self andIsCycle:YES];
    }
}

-(void)alertViewWithTitle:(NSString *)title
           chBtnTitle:(NSString *)cnTitle
               enBtnTitle:(NSString *)okTitle
           cancleBtnTitle:(NSString *)cancleTitle{
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction  *chBtnAction = [UIAlertAction actionWithTitle:cnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [mixPanel track:@"More_Language_Chinese" properties:logInDic];
        [GDLocalizableClass setUserlanguage:@"zh-Hans"];
        /* 切换语言, 修改本地hub信息 */
        [self changeLanguage];
    }];
    
    UIAlertAction  *enBtnAction =   [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [mixPanel track:@"More_Language_English" properties:logInDic];
        
        [GDLocalizableClass setUserlanguage:@"en"];
        /* 切换语言, 修改本地hub信息 */
        [self changeLanguage];
    }];
    
    UIAlertAction   *cancleBtnAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:nil];
    
    [alertCon addAction:chBtnAction];
    [alertCon  addAction:enBtnAction];
    [alertCon addAction:cancleBtnAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

/* 切换语言, 修改本地hub信息 */
- (void)changeLanguage
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]) {
        [HttpRequest getWithUrl:hub_information([[[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]integerValue]) andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error)
         {
             if (!error)
             {
                 if(![response[@"result"] isKindOfClass:[NSNull class]])
                 {
                     _hubModel = [MTLJSONAdapter modelOfClass:[NakedHubModel class] fromJSONDictionary:response[@"result"] error:nil];
                     [[NSUserDefaults standardUserDefaults] setObject:_hubModel.address forKey:@"hubaddress"];
                     [[NSUserDefaults standardUserDefaults] setObject:_hubModel.name forKey:@"hubname"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 
                 
                 //            _hubModel.address = [[NSUserDefaults standardUserDefaults] objectForKey:@"hubaddress"];
                 //            _hubModel.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"hubname"];
                 
                 //            [[NSUserDefaults standardUserDefaults] setObject:@(model.hub.hubId) forKey:@"hubID"];
                 //            [[NSUserDefaults standardUserDefaults] setObject:model.hub.picture forKey:@"hubpicture"];
                 
                 //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                 //            NakedHubMoreHeaderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                 //            cell.hubNameLabel.text = name;
                 //            cell.hubAddressLabel.text = name;
                 //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
             }
             [Utility resetRootViewController];
             [[NSNotificationCenter defaultCenter]postNotificationName:changeLanguageNoti object:nil];
         }];
    }
    else
    {
        [Utility resetRootViewController];
        [[NSNotificationCenter defaultCenter]postNotificationName:changeLanguageNoti object:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BookRoom"]) {
  
        [mixPanel track:@"More_bookRoom" properties:logInDic];

    }
    
    if ([segue.identifier isEqualToString:@"BookWBS"]) {
        
        [mixPanel track:@"More_bookWorkSpace" properties:logInDic];
    }
}

@end

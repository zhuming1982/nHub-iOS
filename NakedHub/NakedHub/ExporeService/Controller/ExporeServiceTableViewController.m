//
//  DDSv1TableViewController.m
//  裸心
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import "ExporeServiceTableViewController.h"
#import "ExporeServicecellTableViewCell.h"
#import "BrandingViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "NHAllServiceViewController.h"
#import "HttpRequest.h"
#import "NHCompaniesDetailsModel.h"
#import "ExporeServiceHeaderView.h"
#import "ExporeServiceFooterView.h"

#import "ExporeServicesModel.h"
#import "UITableView+Refreshing.h"
#import "MainViewController.h"

#define COUNT 10


@interface ExporeServiceTableViewController ()
@property (nonatomic, strong) NSArray *Datasource;

//section Services
@property (nonatomic, strong) NSArray *SecOne_arrayData;
@property (nonatomic, strong) NSMutableArray *SecOne_arrayData2;
//section Companies
@property (nonatomic, strong) NSArray<NHCompaniesDetailsModel*> *SecTwo_arrayData;

@property (nonatomic, strong) NSMutableArray *SecTwo_arrayData2;

@property (nonatomic, assign) NSString *input;
@property (nonatomic,assign) NSInteger page;

@end

@implementation ExporeServiceTableViewController

@synthesize SecOne_arrayData,SecOne_arrayData2,SecTwo_arrayData,SecTwo_arrayData2,Datasource,page;



- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = [GDLocalizableClass getStringForKey:@"Explore"] ;
    
    self.view.backgroundColor=[UIColor whiteColor];
    SecOne_arrayData2 =[[NSMutableArray alloc]init];
    SecTwo_arrayData2 =[[NSMutableArray alloc]init];

    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor=RGBACOLOR(247, 249, 250, 1);

    [self service_datasource];

}
//销毁注册的消息
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//加载数据源
-(void)service_datasource{

    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else
        {
            self.page++;
        }
        
        [HttpRequest getWithUrl:community_index andViewContoller:self andHudMsg:nil andAttributes:nil andBlock:^(id response, NSError *error) {
            if (!error) {
                //Service
                self.SecOne_arrayData = [MTLJSONAdapter modelsOfClass:[ExporeServicesModel class] fromJSONArray:response[@"result"][@"services"] error:nil];
                //Companies
                self.SecTwo_arrayData = [MTLJSONAdapter modelsOfClass:[NHCompaniesDetailsModel class] fromJSONArray:response[@"result"][@"companies"] error:nil];
//                NSLog(@"Companies=%@",self.SecOne_arrayData);
                
            }
            [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:YES];
        }];
    }];
    [self.tableView.header beginRefreshing];
}

//Section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ExporeServiceHeaderView *headView = [[ExporeServiceHeaderView alloc]init];
        if (section ==0){
          headView.title_label.text=[GDLocalizableClass getStringForKey:@"Services Offered by Hubbers"];
        }else{
           headView.title_label.text=[GDLocalizableClass getStringForKey:@"Browse Companies"];
        }
    return headView;
}
//Section Footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ExporeServiceFooterView *footerview=[[ExporeServiceFooterView alloc]init];
    if (section ==0){
        footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"VIEW ALL"];
        [self Footer_tap_service:footerview];
    }else{
        footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"VIEW ALL"];
        [self Footer_tap_company:footerview];
    }
    
    return footerview;
}

//heightForFooterAndHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 74;
}

//numberOfSections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
//numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    static NSString *v1tableviewcell = @"ExporeServicetableviewcell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ExporeServicecellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];

    if(section==0)
    {
        //Services
//        ExporeServicesModel *model= SecOne_arrayData[indexPath.row];
        cell.ServicesModel=SecOne_arrayData[indexPath.row];;
        
        return cell;
        
    }else{
        //Companies
//        NHCompaniesDetailsModel *model =SecTwo_arrayData[indexPath.row];
        cell.CompaniesDetailsModel=SecTwo_arrayData[indexPath.row];;

        return cell;
    }
}

//didSelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = [indexPath section];
    
    if(section==0){
        //service->butVC->companyVC
        BrandingViewController* test2obj=(BrandingViewController*)[Utility pushViewControllerWithStoryboard:@"ExporeService" andViewController:@"BrandingViewController" andParent:self];
        
        ExporeServicesModel *model= SecOne_arrayData[indexPath.row];
        test2obj.title = model.name;
        test2obj.service_id = model.id;

        [mixPanel track:@"Explore_Services_listClick" properties:logInDic];
        
    }
    else{

        //companylistVC->companyVC
        NHCompanyDetailsViewController* company = (NHCompanyDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self];
        
        NHCompaniesDetailsModel *model= SecTwo_arrayData[indexPath.row];
        company.Details_ID = model.id;
       
        [mixPanel track:@"Explore_Companies_listClick" properties:logInDic];


    }
    

}

//add footer tap_action
-(void)Footer_tap_service:(UIView *)tap_view{
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]init];
    [tapg addTarget:self action:@selector(sj_tap1:)];
    tapg.numberOfTapsRequired=1;
    tapg.numberOfTouchesRequired = 1;
    [tap_view setUserInteractionEnabled:YES];
    [tap_view addGestureRecognizer:tapg];
}
-(void)Footer_tap_company:(UIView *)tap_view{
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]init];
    [tapg addTarget:self action:@selector(sj_tap2:)];
    tapg.numberOfTapsRequired=1;
    tapg.numberOfTouchesRequired = 1;
    [tap_view setUserInteractionEnabled:YES];
    [tap_view addGestureRecognizer:tapg];
}

//Footer action View ALL
- (void)sj_tap1:(UIGestureRecognizer*)sender
{

    NHAllServiceViewController* test2obj = (NHAllServiceViewController*)[Utility pushViewControllerWithStoryboard:@"ExporeService" andViewController:@"NHAllServiceViewController" andParent:self];

    test2obj.title = [GDLocalizableClass getStringForKey:@"All Service"];
    [test2obj setHidesBottomBarWhenPushed:YES];
    
    [mixPanel track:@"Explore_Services_viewAll" properties:logInDic];
    
}
- (void)sj_tap2:(UIGestureRecognizer*)sender
{
    [Utility pushViewControllerWithStoryboard:@"ExporeService" andViewController:@"BrandingViewController" andParent:self];
//    BrandingViewController* test2obj = (BrandingViewController*)[Utility pushViewControllerWithStoryboard:@"ExporeService" andViewController:@"BrandingViewController" andParent:self];

//    test2obj.title = [GDLocalizableClass getStringForKey:@"Company"];
//    [test2obj setHidesBottomBarWhenPushed:YES];

    [mixPanel track:@"Explore_Companies_listClick" properties:logInDic];

}

/* 跳转到搜索页面 */
- (IBAction)pushSearchViewController:(id)sender
{
    [mixPanel track:@"Explore_search" properties:logInDic];
    [Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewController" andParent:self];
}


@end








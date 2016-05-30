//
//  BrandingViewController.m
//  裸心p2
//
//  Created by 施豪 on 16/3/18.
//  Copyright © 2016年 施豪. All rights reserved.
//

#import "BrandingViewController.h"
#import "BrandingTableViewCell.h"
#import "NHCompanyDetailsViewController.h"
#import "HttpRequest.h"
#import "UITableView+Refreshing.h"
#import "NHCompaniesDetailsModel.h"
#import "UIImageView+WebCache.h"
#import "MainViewController.h"


#define COUNT 10

@interface BrandingViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSArray *arrayData2;
@property (nonatomic, assign)  NSInteger page;


@end

@implementation BrandingViewController

@synthesize B_tableview,arrayData,arrayData2,service_id;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.title = [GDLocalizableClass getStringForKey:@"Company"];

    arrayData=[[NSMutableArray alloc]init];
    
    self.B_tableview.delegate=self;
    self.B_tableview.dataSource=self;

    [self companies_datasource];
}


-(void)companies_datasource{
    
    @weakify(self)
    [self.B_tableview setRefreshing:^(bool isPull) {
        
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else{
            self.page++;
        }
        
        NSMutableDictionary *attr = service_id!=0?[NSMutableDictionary dictionaryWithDictionary:@{@"serviceId":@(service_id),@"page":@(self.page),@"count":@(COUNT)}]:[NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
        
        NSString *url = service_id != 0?community_service_companies:community_company_list;
        
        [HttpRequest getWithUrl:url andViewContoller:self andHudMsg:nil
                  andAttributes:attr  andBlock:^(id response, NSError *error) {
            NSArray *tempArr = [NSArray array];
            if (!error)
            {
                tempArr =[MTLJSONAdapter modelsOfClass:[NHCompaniesDetailsModel class] fromJSONArray:response[@"result"] error:nil];
                if (isPull)
                {
                    self.arrayData = [NSMutableArray arrayWithArray:tempArr];
                }
                else
                {
                    [self.arrayData addObjectsFromArray:tempArr];
                }
            }
            [self.B_tableview endTableViewRefreshing:isPull andisHiddenFooter:tempArr.count<COUNT];
        }];
        
    }];
    [self.B_tableview.header beginRefreshing];
}

#pragma mark  tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *v1tableviewcell = @"BrandingTableViewCell";
    BrandingTableViewCell *cell = [B_tableview dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
    NHCompaniesDetailsModel *model= arrayData[indexPath.row];
    
    cell.CompaniesDetailsModel=model;
    
//    //自己公司就无法关注
//    if(model.isOwner){
//        cell.Follow_btn.userInteractionEnabled=NO;
//    }else{
//        cell.Follow_btn.userInteractionEnabled=YES;
//    }
    
    
    //cell关注 Action
    @weakify(cell)
    [cell setButtonActionBlock:^(UIButton *btn) {
       
        @strongify(cell)
        NHCompaniesDetailsModel *model= arrayData[indexPath.row];
        NSMutableDictionary *attribute = [NSMutableDictionary dictionaryWithDictionary:@{@"refId":@(model.id),@"type":@"USER2COMPANY"}];
        [HttpRequest postWithURLSession:user_follow andViewContoller:self andHudMsg:@"" andAttributes:attribute andBlock:^(id response, NSError *error) {
            
            if (!error) {
                model.followed = !model.followed;
                //TableView 关注bool
                [cell.Follow_btn setTitle:model.followed?@"":[GDLocalizableClass getStringForKey:@"Follow"]  forState:UIControlStateNormal];
                [cell.Follow_btn setBackgroundColor:model.followed?                RGBACOLOR(220, 220, 223, 1):[UIColor orangeColor]];
                
                if (model.followed) {
                    [cell.Follow_btn setImage:[UIImage imageNamed:@"iconCheck"] forState:UIControlStateNormal];
                }else{
                    [cell.Follow_btn setImage:nil forState:UIControlStateNormal];
                }
            }
            else{
                [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            }
            
        }];
    }];

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NHCompanyDetailsViewController* company=(NHCompanyDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self];

    NHCompaniesDetailsModel *model= arrayData[indexPath.row];
    company.Details_ID = model.id;
    
    BrandingTableViewCell *cell = [B_tableview cellForRowAtIndexPath:indexPath];

     //刷新单条cell上的follow按钮
    [company setFollowBOOL:^(BOOL followed) {
        if (followed) {
            model.followed=YES;
          [cell.Follow_btn setImage:[UIImage imageNamed:@"iconCheck"] forState:UIControlStateNormal];
        }else{
            model.followed=NO;
            [cell.Follow_btn setImage:nil forState:UIControlStateNormal];
        }
        [cell.Follow_btn setTitle:followed?@"":[GDLocalizableClass getStringForKey:@"Follow"]forState:UIControlStateNormal];
        [cell.Follow_btn setBackgroundColor:followed?RGBACOLOR(220, 220, 223, 1):[UIColor orangeColor]];

    }];
    [company setPopName:^(NSString *b_name) {
       cell.title_label.text = b_name;
    }];
    
    
    [mixPanel track:@"Branding_listClick" properties:logInDic];

}


- (IBAction)back_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end









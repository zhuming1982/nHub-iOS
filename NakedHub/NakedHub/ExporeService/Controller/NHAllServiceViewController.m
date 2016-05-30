//
//  NHAllServiceViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/3/30.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHAllServiceViewController.h"
#import "BrandingTableViewCell.h"
#import "NHCompanyDetailsViewController.h"
#import "HttpRequest.h"
#import "UITableView+Refreshing.h"
#import "BrandingViewController.h"
#import "ExporeServicesModel.h"


#define COUNT 10

@interface NHAllServiceViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSArray *arrayData2;
@property (nonatomic, assign)  NSInteger page;

@end

@implementation NHAllServiceViewController

@synthesize allservice_tableview,arrayData,arrayData2;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title= [GDLocalizableClass getStringForKey:@"All Service"] ;
    
    arrayData=[[NSMutableArray alloc]init];
    
    self.allservice_tableview.delegate=self;
    self.allservice_tableview.dataSource=self;
 
    [self service_datasource];
}


//加载数据源
-(void)service_datasource{
    
    @weakify(self)
    [self.allservice_tableview setRefreshing:^(bool isPull) {
        
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else
        {
            self.page++;
        }
        
        [HttpRequest getWithUrl:community_service_list andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}]  andBlock:^(id response, NSError *error) {
            if (!error)
            {
                //Service List
                NSArray *tempArr = [MTLJSONAdapter modelsOfClass:[ExporeServicesModel class] fromJSONArray:response[@"result"] error:nil];
                
                if (isPull){
                    self.arrayData = [NSMutableArray arrayWithArray:tempArr];
                }
                else{
                    [self.arrayData addObjectsFromArray:tempArr];
                }

                [self.allservice_tableview endTableViewRefreshing:isPull andisHiddenFooter:tempArr.count<COUNT];
                
            }
        }];
        
    }];
    
    [self.allservice_tableview.header beginRefreshing];
    
    
}


//heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
    
}
//numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayData.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *v1tableviewcell = @"BrandingTableViewCell";
    
    BrandingTableViewCell *cell = [allservice_tableview dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
//    ExporeServicesModel *model= arrayData[indexPath.row];
    cell.ServicesModel=arrayData[indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BrandingViewController* test2obj=(BrandingViewController*)[Utility pushViewControllerWithStoryboard:@"ExporeService" andViewController:@"BrandingViewController" andParent:self];

    ExporeServicesModel *model= arrayData[indexPath.row];
    test2obj.title = model.name;
    test2obj.service_id = model.id;
    
    [mixPanel track:@"Services_listClick" properties:logInDic];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

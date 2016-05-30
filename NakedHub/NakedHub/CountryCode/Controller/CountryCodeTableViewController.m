//
//  CountryCodeTableViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "CountryCodeTableViewController.h"
#import "CountryCodeTableViewCell.h"
#import "HttpRequest.h"
#import "NHCountryCodeMode.h"
#import "NakedLoginWithPhoneViewController.h"
#import "Constant.h"
#import "LocationManager.h"

@interface CountryCodeTableViewController ()<UISearchResultsUpdating,UISearchControllerDelegate>
@property (nonatomic, strong) NSArray<NHCountryCodeMode*> *DataSource;//接口
@property (strong,nonatomic) NSMutableArray<NHCountryCodeMode *> *searchList;//搜索数据
@property (strong,nonatomic) NSMutableArray  *luan_suoyinList;//乱序索引数组
@property (strong,nonatomic) NSArray  *suoyinList;//排序后索引数组
@property (strong,nonatomic) NSMutableArray  *big_arr;//大数组

@end

@implementation CountryCodeTableViewController
@synthesize ContryTableview,DataSource,seachDC,searchList,suoyinList,big_arr,luan_suoyinList;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title= [GDLocalizableClass getStringForKey:@"Select Area"] ;
    
    self.ContryTableview.dataSource=self;
    self.ContryTableview.delegate=self;
    
    searchList = [[NSMutableArray alloc] init];
    luan_suoyinList = [[NSMutableArray alloc] init];
    big_arr = [[NSMutableArray alloc] init];
 
    [self Country_dataSource];//数据源
    [self seachDC_Fun];//搜索框
    
    
}

//重要 在viewWillDisappear中要将UISearchController移除, 否则切换到下一个View中, 搜索框仍然会有短暂的存在.
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.seachDC.active) {
        self.seachDC.active = NO;
        [self.seachDC.searchBar removeFromSuperview];
    }
}

//numberOfSections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.seachDC.active) {
        return 1;
    }else{
        return big_arr.count;
    }
}
//TitleForHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.seachDC.active) {
        return nil;
    }else{
        return [suoyinList objectAtIndex:section];
    }
}
//heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
//numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.seachDC.active) {
        return [self.searchList count];
    }else{
        return [self.big_arr[section] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *v1tableviewcell = @"CountryCodeTableViewCell";
    CountryCodeTableViewCell *cell = [ContryTableview dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
    
    if (self.seachDC.active)
    {
        cell.Country_name.text = searchList[indexPath.row].name;
        cell.Country_code.text = searchList[indexPath.row].phoneCode;
    }
    else{
        NHCountryCodeMode *model_name= big_arr[indexPath.section][indexPath.row];
        
        cell.Country_name.text =  model_name.name;
        cell.Country_code.text =  model_name.phoneCode;
    }
    return cell;
}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NHCountryCodeMode *model_phoneCode = big_arr[indexPath.section][indexPath.row];
    if (self.seachDC.active) {
//        NSLog(@"搜索国家名＝%@,编码＝%@",searchList[indexPath.row].name,searchList[indexPath.row].phoneCode);
        if (_Country_Back)
        {
            _Country_Back(searchList[indexPath.row].phoneCode);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
//        NSLog(@"当前国家名＝%@,编码＝%@",model_name.name,model_phoneCode.phoneCode);
        if (_Country_Back)
        {
            _Country_Back(model_phoneCode.phoneCode);
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}

//搜索框
-(void)seachDC_Fun{
    
    seachDC = [[UISearchController alloc] initWithSearchResultsController:nil];
    seachDC.searchResultsUpdater = self;
    seachDC.delegate = self;
    seachDC.dimsBackgroundDuringPresentation = NO;
    seachDC.hidesNavigationBarDuringPresentation = YES;
    
    seachDC.searchBar.frame = CGRectMake(self.seachDC.searchBar.frame.origin.x, self.seachDC.searchBar.frame.origin.y, self.seachDC.searchBar.frame.size.width, 44.0);
    // 添加 searchbar 到 headerview
    UITextField *searchField = [self.seachDC.searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont fontWithName:@"Avenir-Roman" size:14];
    
    searchField.textColor = RGBACOLOR(43, 43, 43, 1.0);
    [searchField setValue:RGBACOLOR(43, 43, 43, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.ContryTableview.tableHeaderView = seachDC.searchBar;
    
}


//数据源
-(void)Country_dataSource{
    
    long latitude;
    long longitude;
    
    if ([[LocationManager shared] hasGpsRight]){
            latitude=userLatitude;
            longitude=userlongitude;
        }else{
            latitude=31.22;
            longitude=121.48;
        }
    
 NSMutableDictionary  *attrDic = [NSMutableDictionary dictionaryWithDictionary:@{@"latitude":@(latitude),@"longitude":@(longitude)}];
    
    [HttpRequest getWithUrl:auth_area_phoneCode_list
           andViewContoller:self
                  andHudMsg:@""
              andAttributes:attrDic
                   andBlock:^(id response, NSError *error) {
                       if (!error)
                       {
//                           NSLog(@"latitude=%ld,longitude=%ld",latitude,longitude);
                           self.DataSource = [MTLJSONAdapter modelsOfClass:[NHCountryCodeMode class] fromJSONArray:response[@"result"] error:nil];
                           //索引
                           for (NHCountryCodeMode *model in self.DataSource)
                           {    //如果没含model.index 则加一条(唯一)
                               if (![luan_suoyinList containsObject:model.index])
                               {[luan_suoyinList addObject:model.index];}
                           }
                           // 首字母取出然后排序
                           suoyinList = [luan_suoyinList sortedArrayUsingSelector:@selector(compare:)];
                       }
                       
                       //大数组-- 将每个首字母对应的数据取出放入数组
                       for (NSString *sy in suoyinList)
                       {
                           NSMutableArray *temp_Arr = [NSMutableArray array];
                           for (NHCountryCodeMode *model in self.DataSource)
                           {   //匹配索引数组 如果吻合则加入数组
                               if ([model.index isEqualToString:sy])
                               {
                                   [temp_Arr addObject:model];
                               }
                           }
                           [big_arr addObject:temp_Arr];
                       }
                       [self.ContryTableview reloadData];
                   }];
    
}


#pragma mark    searchControllerDelegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.seachDC.searchBar text];
    //初始化搜索框内容
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //匹配大数组内数据字段
    for (NSArray *arr in big_arr)
    {
        for (NHCountryCodeMode *one in arr)
        {
            if (([one.index rangeOfString:searchString].location!=NSNotFound)||([one.index isEqualToString:searchString])||([one.index isEqualToString:[searchString uppercaseString]])||([one.name rangeOfString:searchString].location!=NSNotFound)||([one.phoneCode rangeOfString:searchString].location!=NSNotFound))
            {
                [searchList addObject:one];
            }
        }
    }
    
    [self.ContryTableview reloadData];
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end












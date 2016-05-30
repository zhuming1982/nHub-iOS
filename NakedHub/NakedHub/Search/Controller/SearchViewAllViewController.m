//
//  SearchViewAllViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/20.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchViewAllViewController.h"

#import "UITableView+Refreshing.h"

#import "SearchHeaderView.h"
#import "SearchMembersCell.h"
#import "SearchCompaniesCell.h"
#import "SearchEventsCell.h"
#import "SearchPostCell.h"

#import "NakedUserModel.h"
#import "NHCompaniesDetailsModel.h"
#import "NakedEventsModel.h"
#import "NakedHubFeedModel.h"

#import "NakedPerSonalDetailsViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "NakedEventsDetailViewController.h"
#import "NakedHubFeedDetailsViewController.h"

#define COUNT 10

@interface SearchViewAllViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *viewAllArray;
@property (nonatomic, copy) NSString *viewAllString; // 数量

@end

@implementation SearchViewAllViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [GDLocalizableClass getStringForKey:@""];
    
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull)
     {
         @strongify(self)
         if (isPull) {
             self.page = 1;
         } else {
             self.page++;
         }
         
         [HttpRequest getWithUrl:searchByKeyWordAndType andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page) , @"count" : @(COUNT), @"keyword" : _keyWord , @"type" : _resultUnitType}] andBlock:^(id response, NSError *error)
          {
              if (!error)
              {
                  //View All List
                  NSError *Error = nil;
                  NSArray *viewAllList;
                  
                  if ([response[@"result"] isKindOfClass:[NSNull class]]) {
                      /* 正好有10条数据的时候如果返回空, 这里就咬加判断 */
                  } else {
                      
                      if (!_viewAllString) {
                          _viewAllString = [NSString stringWithFormat:@"%@", response[@"result"][@"count"]];
                      }
                      
                      if ([_resultUnitType isEqualToString:@"USER"]) {
                          viewAllList = [MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"][@"users"] error:&Error];
                      } else if ([_resultUnitType isEqualToString:@"COMPANY"]) {
                          viewAllList = [MTLJSONAdapter modelsOfClass:[NHCompaniesDetailsModel class] fromJSONArray:response[@"result"][@"companies"] error:&Error];
                      } else if ([_resultUnitType isEqualToString:@"EVENT"]) {
                          viewAllList = [MTLJSONAdapter modelsOfClass:[NakedEventsModel class] fromJSONArray:response[@"result"][@"events"] error:&Error];
                      } else {
                          viewAllList = [MTLJSONAdapter modelsOfClass:[NakedHubFeedModel class] fromJSONArray:response[@"result"][@"feeds"] error:&Error];
                      }
                      
                      if (isPull){
                          _viewAllArray = [NSMutableArray arrayWithArray:viewAllList];
                      } else {
                          [_viewAllArray addObjectsFromArray:viewAllList];
                      }
                  }
                  [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:viewAllList.count < COUNT];
              }
          }];
     }];
    [self.tableView.header beginRefreshing];
}

#pragma mark - TableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];

    if ([_resultUnitType isEqualToString:@"USER"] && _viewAllString != nil) {
        headerView.headerLabel.text = 1 == _viewAllArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ member"], @"1"]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ members"], _viewAllString];
    } else if ([_resultUnitType isEqualToString:@"COMPANY"] && _viewAllString != nil) {
        headerView.headerLabel.text = 1 == _viewAllArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ company"], @"1"]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ companies"], _viewAllString];
    } else if ([_resultUnitType isEqualToString:@"EVENT"] && _viewAllString != nil) {
        headerView.headerLabel.text = 1 == _viewAllArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ event"], @"1"]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ events"], _viewAllString];
    } else {
        if (_viewAllString != nil) {
            headerView.headerLabel.text = 1 == _viewAllArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ post"], @"1"]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ posts"], _viewAllString];
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewAllArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_resultUnitType isEqualToString:@"USER"]) {
        SearchMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchMembersCell" forIndexPath:indexPath];
        cell.searchMembersModel = _viewAllArray[indexPath.row];
        return cell;
    } else if ([_resultUnitType isEqualToString:@"COMPANY"]) {
        SearchCompaniesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCompaniesCell" forIndexPath:indexPath];
        cell.searchCompaniesModel = _viewAllArray[indexPath.row];
        return cell;
    } else if ([_resultUnitType isEqualToString:@"EVENT"]) {
        SearchEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchEventsCell" forIndexPath:indexPath];
        cell.searchEventsModel = _viewAllArray[indexPath.row];
        return cell;
    } else {
        SearchPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPostCell" forIndexPath:indexPath];
        cell.searchPostModel = _viewAllArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_resultUnitType isEqualToString:@"USER"]) {
        // 成员详情界面
        [mixPanel track:@"Search_viewAll_membersListClick" properties:logInDic];
        ((NakedPerSonalDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:self]).userModel = (NakedUserModel *)_viewAllArray[indexPath.row];
    } else if ([_resultUnitType isEqualToString:@"COMPANY"]) {
        // 公司详情界面
        [mixPanel track:@"Search_viewAll_companiesListClick" properties:logInDic];
        ((NHCompanyDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self]).Details_ID = ((NHCompaniesDetailsModel *)_viewAllArray[indexPath.row]).id;
    } else if ([_resultUnitType isEqualToString:@"EVENT"]) {
        // 活动详情页面
        [mixPanel track:@"Search_viewAll_eventsListClick" properties:logInDic];
        ((NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self]).eventsId = ((NakedEventsModel *)_viewAllArray[indexPath.row]).eventsId;
    } else {
        // feed 详情界面
        [mixPanel track:@"Search_viewAll_postsListClick" properties:logInDic];
        ((NakedHubFeedDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController" andParent:self]).feedModel = (NakedHubFeedModel *)_viewAllArray[indexPath.row];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

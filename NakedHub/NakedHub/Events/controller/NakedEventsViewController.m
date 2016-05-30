//
//  NakedEventsViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsViewController.h"

#import "NakedEventsDetailViewController.h"
#import "NakedEventsFilterViewController.h"
#import "NakedEventsCell.h"
#import "NakedEventsModel.h"
#import "UITableView+Refreshing.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NakedEventsFilter.h"

#define COUNT 10

@interface NakedEventsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<NakedEventsModel*> *eventsArray;

@property (nonatomic, strong) NSDictionary *filterDictionary; // 筛选活动字典

@end

@implementation NakedEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 340;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = [GDLocalizableClass getStringForKey:@"Events"];
    [self httpRequestWithData];
   [self.tableView.header beginRefreshing];
}

- (void)httpRequestWithData
{
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull)
     {
         @strongify(self)
         if (isPull) {
             self.page = 1;
         } else {
             self.page++;
         }
         
         NSMutableDictionary *mutableDictinary;
         if (_filterDictionary) {
             if (_filterDictionary[@"categoryId"]) {
                 mutableDictinary = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page), @"count" : @(COUNT), @"region" : _filterDictionary[@"region"], @"categoryId" : _filterDictionary[@"categoryId"]}];
             } else {
                 mutableDictinary = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page), @"count" : @(COUNT), @"region" : _filterDictionary[@"region"]}];
             }
         } else {
             mutableDictinary = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page), @"count" : @(COUNT)}];
         }
         
         [HttpRequest getWithUrl:events_list andViewContoller:self andHudMsg:nil andAttributes:mutableDictinary andBlock:^(id response, NSError *error)
          {
              if (!error)
              {
                  //Event List
                  NSError *Error = nil;
                  NSArray *eventList = [MTLJSONAdapter modelsOfClass:[NakedEventsModel class] fromJSONArray:response[@"result"] error:&Error];
                  
                  if (isPull){
                      _eventsArray = [NSMutableArray arrayWithArray:eventList];
                  } else {
                      [_eventsArray addObjectsFromArray:eventList];
                  }
                  [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:eventList.count < COUNT];
              }
          }];
     }];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NakedEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsCell" forIndexPath:indexPath];
    cell.eventsModel = _eventsArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - empty tableView 没有数据时, 展示一张图片
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIColor *need_color = RGBACOLOR(136, 139, 144, 1);
    
    NSString *testStr = [GDLocalizableClass getStringForKey:@"No results match"];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    NSDictionary *attribs = @{
                              NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:16.0f],
                              NSParagraphStyleAttributeName:ps,
                              NSForegroundColorAttributeName:need_color
                              };
    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:testStr attributes:attribs];
    
    return attributedText;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Noresultsmatch"];
}

/* 调整没有数据时, 调整 Noresultsmatch 图片的垂直距离, 默认居中 */
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -(kScreenHeight / 5);
//}

- (IBAction)filterEvents:(id)sender
{
    [mixPanel track:@"Events_filter" properties:logInDic];
    NakedEventsFilterViewController *eventsFilterViewController = [[UIStoryboard storyboardWithName:@"Events" bundle:nil] instantiateViewControllerWithIdentifier:@"nakedEventsFilterViewController"];
//    eventsFilterViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:eventsFilterViewController animated:YES completion:^{
        [eventsFilterViewController setFilterEvents:^(NSDictionary *filterDictionary) {
            _filterDictionary = filterDictionary;
            [self.tableView.header beginRefreshing];
        }];
    }];
}

// 返回上个页面
- (IBAction)back:(id)sender
{
    [[NakedEventsFilter shareInstance] removeFilterDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [mixPanel track:@"Events_listClick" properties:logInDic]; // 跳转到活动详情页面
    
    NakedEventsDetailViewController *eventDetailViewController = [segue destinationViewController];
    eventDetailViewController.eventsId = _eventsArray[self.tableView.indexPathForSelectedRow.row].eventsId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

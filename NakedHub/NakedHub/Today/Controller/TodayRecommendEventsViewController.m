//
//  TodayRecommendEventsViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "TodayRecommendEventsViewController.h"

#import "NakedEventsDetailViewController.h"
#import "NakedEventsCell.h"
#import "NakedEventsModel.h"
#import "UITableView+Refreshing.h"
#import "UIScrollView+EmptyDataSet.h"

#define COUNT 10

@interface TodayRecommendEventsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<NakedEventsModel*> *recommendArray;

@end

@implementation TodayRecommendEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [GDLocalizableClass getStringForKey:@"UPCOMING EVENTS"];
    
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull)
     {
         @strongify(self)
         if (isPull) {
             self.page = 1;
         } else {
             self.page++;
         }
         
         [HttpRequest getWithUrl:today_events andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page), @"count" : @(COUNT), @"queryUnit" : _queryUnit}] andBlock:^(id response, NSError *error)
          {
              if (!error)
              {
                  //Event List
                  NSError *Error = nil;
                  NSArray *recommendList = [MTLJSONAdapter modelsOfClass:[NakedEventsModel class] fromJSONArray:response[@"result"] error:&Error];
                  
                  if (isPull){
                      _recommendArray = [NSMutableArray arrayWithArray:recommendList];
                  } else {
                      [_recommendArray addObjectsFromArray:recommendList];
                  }
                  [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:recommendList.count < COUNT];
              }
          }];
     }];
    [self.tableView.header beginRefreshing];
    
    self.tableView.estimatedRowHeight = 340;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NakedEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsCell" forIndexPath:indexPath];
    cell.eventsModel = _recommendArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 跳转到活动详情页面
    [mixPanel track:@"UpComing_Events_listClick" properties:logInDic];
    NakedEventsDetailViewController *eventsDetailViewController = (NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self];
    eventsDetailViewController.eventsId = _recommendArray[indexPath.row].eventsId;
    eventsDetailViewController.isRefresh = YES;
    NakedEventsModel *eventsModel = _recommendArray[indexPath.row];

    @weakify(self)
    [eventsDetailViewController setPopBack:^(NSInteger modelEventsId) {
        @strongify(self)
        if (eventsModel.eventsId == modelEventsId)
        {
            [self.recommendArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }

    }];
    [eventsDetailViewController setPopRecommendBack:^{
        [self.tableView reloadData];
    }];
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
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -(kScreenHeight / 5);
}

- (IBAction)back:(id)sender
{
    if (_popTodayBack) {
        _popTodayBack(_recommendArray);
    }
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

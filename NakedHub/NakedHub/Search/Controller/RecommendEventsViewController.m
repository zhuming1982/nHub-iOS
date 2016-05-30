//
//  RecommendEventsViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/23.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "RecommendEventsViewController.h"

#import "NakedEventsDetailViewController.h"
#import "NakedEventsCell.h"
#import "NakedEventsModel.h"
#import "UITableView+Refreshing.h"

#define COUNT 10

@interface RecommendEventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<NakedEventsModel*> *recommendArray;

@end

@implementation RecommendEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [GDLocalizableClass getStringForKey:@"Events"];
    
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull)
     {
         @strongify(self)
         if (isPull) {
             self.page = 1;
         } else {
             self.page++;
         }
         
         [HttpRequest getWithUrl:search_recommend_detail andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page), @"count" : @(COUNT), @"type" : @"EVENT"}] andBlock:^(id response, NSError *error)
          {
              if (!error)
              {
                  //Event List
                  NSError *Error = nil;
                  NSArray *recommendList = [MTLJSONAdapter modelsOfClass:[NakedEventsModel class] fromJSONArray:response[@"result"][@"events"] error:&Error];
                  
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
    [mixPanel track:@"Search_thisWeek_eventsListClick" properties:logInDic];
    ((NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self]).eventsId = _recommendArray[indexPath.row].eventsId;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

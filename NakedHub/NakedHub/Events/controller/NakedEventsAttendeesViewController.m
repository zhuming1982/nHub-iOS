//
//  NakedEventsAttendeesViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsAttendeesViewController.h"

#import "NakedEventsAttendeesCell.h"
#import "NakedEventsAttendeesModel.h"
#import "UITableView+Refreshing.h"
#import "HttpRequest.h"
#import "NakedPerSonalDetailsViewController.h"

#define COUNT 20

@interface NakedEventsAttendeesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<NakedEventsAttendeesModel *> *attendeesArray;

@end

@implementation NakedEventsAttendeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull)
    {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        } else {
            self.page++;
        }
        
        [HttpRequest getWithUrl:events_attendees(_eventsId) andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(self.page) , @"count" : @(COUNT)}] andBlock:^(id response, NSError *error)
         {
             if (!error)
             {
                 NSString *count = [NSString stringWithFormat:@"%@", response[@"result"][@"participatorCount"]];
                 self.title = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ Attendees"], count];
                 
                 NSArray *attendeesList = [MTLJSONAdapter modelsOfClass:[NakedEventsAttendeesModel class] fromJSONArray:response[@"result"][@"participators"] error:nil];
                 
                 if (isPull){
                     _attendeesArray = [NSMutableArray arrayWithArray:attendeesList];
                 } else {
                     [_attendeesArray addObjectsFromArray:attendeesList];
                 }
                 [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:attendeesList.count < COUNT];
             }
         }];
    }];
    
    [self.tableView.header beginRefreshing];
    
//    self.tableView.estimatedRowHeight = 94;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _attendeesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NakedEventsAttendeesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsAttendeesCell" forIndexPath:indexPath];
    cell.attendeesModel = _attendeesArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [mixPanel track:@"Event_Detail_Attendees_listClick" properties:logInDic];
    // 跳转到参与者详情页面 下面传 Model
    NakedUserModel *userModel = [[NakedUserModel alloc] init];
    userModel.userId = _attendeesArray[indexPath.row].attendId;
    ((NakedPerSonalDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:self]).userModel = userModel;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  NotificationsListTableViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NotificationsListTableViewController.h"
#import "NotificationsTableViewCell.h"
#import "HttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UITableView+Refreshing.h"
#import "NHNotificationsModel.h"

//push
#import "NakedHubFeedDetailsViewController.h"
#import "NakedPerSonalDetailsViewController.h"
#import "NHReservationsDetailViewController.h"

#define COUNT 10

@interface NotificationsListTableViewController ()
@property (nonatomic, strong) NSArray *push_arr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *arrayData;

@end

@implementation NotificationsListTableViewController
@synthesize push_arr,arrayData,NotType_str;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayData=[[NSMutableArray alloc]init];
    self.title= [GDLocalizableClass getStringForKey:@"Notifications"];
    
//    self.tableView.estimatedRowHeight = 400;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self updata];
    //当前页面收到消息后刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NewMessage) name:@"applicationStateActive" object:nil];
}

//销毁注册的消息
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//推送消息后 刷新数据
-(void)NewMessage{
    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(updata) object:nil];
    [self performSelector:@selector(updata) withObject:nil afterDelay:0.5];
}

////独立数据
//-(void)loadData{
//
//}
//上拉加载数据
-(void)updata{
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        
        if (isPull) {
            self.page = 1;
        }
        else{
            self.page++;
        }
        
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
//        if (self.NotType_str!=nil&&self.NotType_str.length>0) {
//            [attr setObject:self.NotType_str forKey:@"queryUnit"];
//        }
        @weakify(self)
        [HttpRequest getWithUrl:today_pushMessages andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
            if (!error) {
                @strongify(self)
                self.push_arr = [MTLJSONAdapter modelsOfClass:[NHNotificationsModel class] fromJSONArray:response[@"result"] error:nil];
                if (isPull)
                {
                    self.arrayData = [NSMutableArray arrayWithArray:self.push_arr];
                }
                else
                {
                    [self.arrayData addObjectsFromArray:self.push_arr];
                }
                [self.tableView endTableViewRefreshing:self.page==1 andisHiddenFooter:push_arr.count<COUNT];
            }
            
        }];
    }];
    [self.tableView.header beginRefreshing];
}

//标记有没有已标记
-(void)push_message_mark:(NSInteger)mark{
    
    NSMutableDictionary *read_dic=[NSMutableDictionary dictionaryWithDictionary:@{@"messageId":@(mark)}];
    
    [HttpRequest postWithURLSession:message_pushmessage_mark andViewContoller:self andHudMsg:nil andAttributes:read_dic  andBlock:^(id response, NSError *error) {
        if (!error) {
            [Utility BadgeNumChanged:NO withBadgeNum:@"1"];
            if(_readBOOL){
                _readBOOL(arrayData);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *v1tableviewcell = @"NotificationsTableViewCell";
    
    NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
    cell.NotificationsModel=arrayData[indexPath.row];
    cell.red_image.hidden=YES;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [mixPanel track:@"Notifications_listClick" properties:logInDic];
    NHNotificationsModel *model=arrayData[indexPath.row];
    NotificationsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(model.read==NO){
        //未读消息转已读
        cell.red_image.backgroundColor=[UIColor clearColor];
        model.read = YES;
        [self push_message_mark:model.id];
    }
    [self PushVCType:model];
    
}

//跳转逻辑
-(void)PushVCType:(NHNotificationsModel*)model{\
    //跳转用户动态
    if ([model.pushSign isEqualToString:@"FEED_COMMENT"]||[model.pushSign isEqualToString:@"FEED_LIKE"]||[model.pushSign isEqualToString:@"FEED_FOLLOWER_POST"]||[model.pushSign isEqualToString:@"COMMENT_LIKE"]){
        //        NSLog(@"跳转用户动态skipModelId=%ld",(long)model.skipModelId);
        NakedHubFeedDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController"];
        
        if(model.skip){
            if (model.skipModelId==0) {
                //            NSLog(@"取消点赞");
            }else{
                DetailVC.feedModelId=model.skipModelId;
                [DetailVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:DetailVC animated:YES];
            }
        }
    }
    //推送跳转到用户详情
    else if ([model.pushSign isEqualToString:@"USER_FOLLOW"]){
        //        NSLog(@"跳转用户详情skipModelId=%ld",(long)model.skipModelId);
        NakedPerSonalDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController"];
        
        if(model.skip){
            NakedUserModel *userM=[[NakedUserModel alloc]init];
            userM.userId=model.skipModelId;
            DetailVC.userModel=userM;
            [DetailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:DetailVC animated:YES];
        }
    }
    //推送跳转到预定记录详情
    else if ([model.pushSign isEqualToString:@"RESERVATION_CONFIRM"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_CONFIRM_START"]||[model.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_START"]||[model.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_UPCOMING"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_UPCOMING"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_START"]){
        //USER_MEMBERSHIP_EXPIRING 目前先不加入进去
        //NSLog(@"跳转预定记录详情skipModelId=%ld",(long)model.skipModelId);
        NHReservationsDetailViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationsDetailViewController"];
        
        if(model.skip){
            DetailVC.Reservation_id=model.skipModelId;
            [DetailVC setHidesBottomBarWhenPushed:YES];
            DetailVC.is_mores=YES;
            //如果用户在预定详情点击取消 返回通知列表可以避免再次进入空页面
            [DetailVC setPopNotification:^(BOOL iscancel) {
                if (iscancel) {
                    model.skip=NO;
                }
            }];
            
            [self.navigationController pushViewController:DetailVC animated:YES];
        }
    }
    else{
        NSLog(@"未找到对应跳转界面");
    }
}

- (IBAction)BACK:(id)sender {
    if(_readBOOL){
        _readBOOL(arrayData);
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}


@end

//
//  NHTodayListTableViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/4/6.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHTodayListTableViewController.h"
#import "ExporeServicecellTableViewCell.h"
#import "NHTodayListTableViewController.h"
#import "NotificationsListTableViewController.h"
#import "NotificationsTableViewCell.h"
#import "NHReservationsDetailViewController.h"
#import "NHReservationListViewController.h"
#import "NakedHubBWSViewController.h"
#import "NakedBookRoomViewController.h"
#import "ExporeServiceHeaderView.h"
#import "ExporeServiceFooterView.h"

#import "HttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UITableView+Refreshing.h"
#import "NakedBookRoomModel.h"
#import "NHNotificationsModel.h"
#import "NHReservationOrdersListModel.h"
#import "Utility.h"
#import "NHqueryUnitModel.h"

//push
#import "NakedHubFeedDetailsViewController.h"
#import "NakedPerSonalDetailsViewController.h"

#import "LMDropdownView.h"
#import "NakedMenuCell.h"

#import "URLSingleton.h"
#import "NakedEventsModel.h"
#import "SearchEventsCell.h"
#import "NakedEventsDetailViewController.h"
#import "TodayRecommendEventsViewController.h"

#define COUNT 10

@interface NHTodayListTableViewController ()<LMDropdownViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *SecOne_arrayData;
@property (nonatomic, strong) NSArray *SecTwo_arrayData;
@property (nonatomic, strong) NSMutableArray<NakedEventsModel *> *SecThree_arrayData; // events
@property (nonatomic, strong) NSArray *book_arr;

@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) IBOutlet UITableView *todayTableView;

@property (weak, nonatomic) IBOutlet UIButton *menuTitleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;
@property (strong, nonatomic) IBOutlet UITableView *menuTitleTableView;
@property (strong, nonatomic) NSArray<NHqueryUnitModel *>  *menuTitleArray;
@property (strong, nonatomic)  LMDropdownView  *dropdownView;
@property (copy, nonatomic) NSString  *queryUnits_str;

@end

@implementation NHTodayListTableViewController
@synthesize SecOne_arrayData,SecTwo_arrayData,book_arr,menuTitleArray,dropdownView;
//顶部下拉按钮
- (IBAction)selectionViewBtn:(id)sender {
    if (self.menuTitleArray.count==0) {
        [self loadTitleMenuData];
    }
    [self showDropDownViewFromDirection:LMDropdownViewDirectionTop];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([URLSingleton sharedURLSingleton].isUpDateToday == YES) {
        [self loadDate];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.dropdownView.isOpen) {
        [self.dropdownView hide];
    }
}
-(void)loadTitleMenuData
{
    @weakify(self)
    [HttpRequest getWithUrl:today_queryUnits andViewContoller:nil andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            self.menuTitleArray =  [MTLJSONAdapter modelsOfClass:[NHqueryUnitModel class] fromJSONArray:response[@"result"] error:nil];
            self.menuTitleTableView.frame = CGRectMake(CGRectGetMinX(self.menuTitleTableView.frame),CGRectGetMinY(self.menuTitleTableView.frame),
                                                       CGRectGetWidth(self.view.bounds),
                                                       MIN(CGRectGetHeight(self.view.bounds) - 44, self.menuTitleArray.count * 44));
            [self.menuTitleTableView reloadData];
        }
        
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.queryUnits_str = @"TODAY";
    [self.menuTitleBtn setTitle:[GDLocalizableClass getStringForKey:@"Today"] forState:UIControlStateNormal];

    self.view.backgroundColor=[UIColor whiteColor];
    self.todayTableView.backgroundColor= RGBACOLOR(247, 249, 250, 1);
    //过滤接口
    [self loadTitleMenuData];
    [self uploaddate];

    //当前页面收到推送消息后刷新NeedReloadVC
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(use_loadDate) name: @"applicationStateActive" object:nil];
    //more和notification界面通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(use_loadDate) name: @"NeedReloadVC" object:nil];
    
    /* 参加活动 收到通知 刷新页面 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToday) name:@"refreshToday" object:nil];
}

//销毁注册的消息
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//创建一个方法避免多条推送同时收到产生冲突
-(void)use_loadDate{
    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDate) object:nil];
    [self performSelector:@selector(loadDate) withObject:nil afterDelay:0.5];
}
//独立数据
-(void)loadDate{
    NSMutableDictionary *attr = [[NSMutableDictionary alloc]init];
    
    if (self.queryUnits_str.length>0&&self.queryUnits_str!=nil) {
        [attr setObject:self.queryUnits_str forKey:@"queryUnit"];
    }
    @weakify(self)
    [HttpRequest getWithUrl:today_index andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            //消息推送列表
            self.SecOne_arrayData = [MTLJSONAdapter modelsOfClass:[NHNotificationsModel class] fromJSONArray:response[@"result"][@"pushMessages"] error:nil];
            //预定列表
            self.SecTwo_arrayData = [MTLJSONAdapter modelsOfClass:[NHReservationOrdersListModel class] fromJSONArray:response[@"result"][@"reservationRecords"] error:nil];
            // events
            _SecThree_arrayData = [MTLJSONAdapter modelsOfClass:[NakedEventsModel class] fromJSONArray:response[@"result"][@"events"] error:nil];
            //判断 如果标题＝今天且小于等于2条 清空角标
            if([self.queryUnits_str isEqualToString:@"TODAY"])
            {
                if(self.SecOne_arrayData.count<=2)
                {
                    [Utility BadgeNumChanged:NO withBadgeNum:@"Read_All"];
                }
            }
            
             [URLSingleton sharedURLSingleton].isUpDateToday = NO;
            
        }
        [self.todayTableView endTableViewRefreshing:self.page==1 andisHiddenFooter:YES];
    }];
}
//上拉加载数据
-(void)uploaddate{
    @weakify(self)
    [self.todayTableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else{
            self.page++;
        }
        [self loadDate];

    }];
    [self.todayTableView.header beginRefreshing];
    
}
//标记未读消息接口
-(void)push_message_mark:(NSInteger)mark{
    NSMutableDictionary*read_dic=[NSMutableDictionary dictionaryWithDictionary:@{@"messageId":@(mark)}];
    
    [HttpRequest postWithURLSession:message_pushmessage_mark andViewContoller:nil andHudMsg:nil andAttributes:read_dic  andBlock:^(id response, NSError *error) {
        if (!error) {
            [Utility BadgeNumChanged:NO withBadgeNum:@"1"];
            [self UnReadCount];
        }
    }];
}
//刷新消息列表
-(void)UnReadCount{
    //一个section刷新(为了刷新？条未读消息)
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.todayTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refreshToday
{
    [self.todayTableView.header beginRefreshing];
}

- (void)showDropDownViewFromDirection:(LMDropdownViewDirection)direction
{
    // Init dropdown view
    if (!self.dropdownView) {
        self.dropdownView = [LMDropdownView dropdownView];
        self.dropdownView.delegate = self;
        self.dropdownView.contentBackgroundColor = [UIColor clearColor];
        // Customize Dropdown style
        self.dropdownView.closedScale = 1.0;
        self.dropdownView.blurRadius = 15;
        self.dropdownView.blackMaskAlpha = 0.0;
        self.dropdownView.animationDuration = 0.3;
        self.dropdownView.animationBounceHeight = 0;
    }
    self.dropdownView.direction = direction;
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
        [UIView animateWithDuration:0.1 animations:^{
            self.downImage.transform = CGAffineTransformIdentity; // All Location 箭头还原
        }];
        
    }
    else {
        switch (direction) {
                
            case LMDropdownViewDirectionTop: {
                [ UIView animateWithDuration:0.1 animations:^{
                    self.downImage.transform = CGAffineTransformMakeRotation(M_PI); // All Location 箭头旋转向下
                } completion:^(BOOL finished) {
                    
                    [self.dropdownView showFromNavigationController:self.navigationController
                                                    withContentView:self.menuTitleTableView];
                }];
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - LMDropdownViewDelegate
- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView{
    [UIView animateWithDuration:0.1 animations:^{
        self.downImage.transform = CGAffineTransformIdentity; // All Location 箭头还原
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Section header *
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 1000) {
        return nil;
    }else{
        
    ExporeServiceHeaderView *headView = [[ExporeServiceHeaderView alloc]init];
    if (section ==0){
        if (SecOne_arrayData.count==0) {
         headView.title_label.text=@"";
        }else{
         headView.title_label.text=[GDLocalizableClass getStringForKey:@"NOTIFICATIONS"];
        }
    } else if(1 == section) {
        if (SecTwo_arrayData.count==0) {
        headView.title_label.text=[GDLocalizableClass getStringForKey:@"UPCOMING RESERVATIONS"];
        }else{
        headView.title_label.text=[GDLocalizableClass getStringForKey:@"UPCOMING RESERVATIONS"];
        }
    } else {
        headView.title_label.text = [GDLocalizableClass getStringForKey:@"UPCOMING EVENTS"];
    }
    return headView;
   }
}
//Section Footer *
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView.tag == 1000) {
        return nil;
    }
   
    ExporeServiceFooterView *footerview=[[ExporeServiceFooterView alloc]init];
    if (section ==0){
        //Notifications No new notification
        if (SecOne_arrayData.count==0) {
            //0条消息 不显示Footer“更多”
            footerview.Foot_label.text=@"";
        } else {
            if(SecOne_arrayData.count>=3){
                
            NSInteger intString = [[[NSUserDefaults standardUserDefaults]objectForKey:BadgeNumKeyForNSUserDefault] intValue];
                
            NSString  *badgeNum = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"+%ld UNREAD"],intString];
                if (intString <=0) {
                    footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"MORE"];
                }
                else{
                    footerview.Foot_label.text=badgeNum;
                }
                [self Footer_tap_Notifications:footerview];
            }
            else{
            //1-2条消息 不显示Footer“更多”
            footerview.Foot_label.text=@"";
            }
        }
        return footerview;
    } else if(1 == section) {
        //Book or Reservation
        if (SecTwo_arrayData.count==0){
            footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"BOOK NOW"];
        }else{
            if (SecTwo_arrayData.count>0){
            footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"VIEW ALL"];
            }
        }
        [self Footer_tap_booking:footerview];
        return footerview;
    } else {
        if (_SecThree_arrayData.count == 0 || _SecThree_arrayData.count > 2) {
            footerview.Foot_label.text=[GDLocalizableClass getStringForKey:@"SHOW MORE"];
        } else {
            return nil;
        }
        [self footerTapGestureRecognizer:footerview];
        return footerview;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return 0.0;
    }
    else{
        if(section==0){
            return SecOne_arrayData.count==0?0.01:44;
        } else {
            return 44;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView.tag == 1000)
    {
        return 0.0;
    }
    if(section==0){
        return SecOne_arrayData.count == 0 ? 0.01 : 74;
    } else if (2 == section) {
        return 0 < _SecThree_arrayData.count ? (2 < _SecThree_arrayData.count ? 74 : 0.01): 74;
    } else {
        return 74;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  tableView.tag == 1000 ? 1 : 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        return 44;
    }
    if(indexPath.section==0){
        return SecOne_arrayData.count==0?0:94;
    }else{
        return 94;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1000) {
        return  menuTitleArray.count;
    }
   
    if (section==0){
        return SecOne_arrayData.count<=3&&SecOne_arrayData.count!=0?SecOne_arrayData.count:3;
    } else if(1 == section) {
      
        if (SecTwo_arrayData.count==0){
            return 1;
        }else if(SecTwo_arrayData.count>=3){
            return 3;
        }else{
            return SecTwo_arrayData.count;
        }
    } else {
        if (0 == _SecThree_arrayData.count) {
            return 1;
        } else if(_SecThree_arrayData.count > 3){
            return 3;
        } else {
            return _SecThree_arrayData.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1000)
    {
        if (menuTitleArray.count>0)
        {
            NakedMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedMenuCell" forIndexPath:indexPath];
            cell.titleLabel.text = menuTitleArray[indexPath.row].name;
            return cell;
        }
    }
    
    //消息列表
    if(0 == indexPath.section)
    {
        NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsTableViewCell" forIndexPath:indexPath];
        
        if(SecOne_arrayData.count==0){
            return cell;
        }else{
            cell.NotificationsModel=SecOne_arrayData[indexPath.row];
            return cell;
        }
        
    } else if(1 == indexPath.section) {
        NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsTableViewCell" forIndexPath:indexPath];
        
        //预定列表orBook
        if (SecTwo_arrayData.count>0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.ReservationOrdersListModel=SecTwo_arrayData[indexPath.row];

            return cell;
        } else {
            //Need Book
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.Title_label.text =[GDLocalizableClass getStringForKey:@"You have no upcoming reservations."] ;
            cell.Time_label.text =[GDLocalizableClass getStringForKey:@"Have a meeting? Book now!"];
            cell.Left_image.image = [UIImage imageNamed:@"noUpcoming"];
            cell.red_image.backgroundColor =[UIColor clearColor];

            return cell;
        }
    } else {
        if (_SecThree_arrayData.count > 0) {
            SearchEventsCell *eventsCell = [tableView dequeueReusableCellWithIdentifier:@"searchEventsCell" forIndexPath:indexPath];
            eventsCell.isToday = YES;
            eventsCell.searchEventsModel = _SecThree_arrayData[indexPath.row];
            return eventsCell;
        } else {
            NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsTableViewCell" forIndexPath:indexPath];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.Title_label.text = [GDLocalizableClass getStringForKey:@"No more upcoming events nearby."] ;
            cell.Time_label.text = [GDLocalizableClass getStringForKey:@"View upcoming events at all Hubs."];
            cell.Left_image.image = [UIImage imageNamed:@"eventsUpcoming"];
            cell.red_image.backgroundColor =[UIColor clearColor];
            return cell;
        }
    }
}

//didSelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSUInteger section = [indexPath section];
    if (tableView.tag == 1000) {
            if (menuTitleArray.count>0) {
                
                [_menuTitleBtn setTitle:menuTitleArray[indexPath.row].name forState:UIControlStateNormal];
                self.queryUnits_str=menuTitleArray[indexPath.row].queryUnit;
            }
        [self.dropdownView hide];
        [self.todayTableView.header beginRefreshing];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.downImage.transform = CGAffineTransformIdentity; // All Location 箭头还原
        }];
        
        return;
    }
    
    //Notification
    if(section==0){
        [mixPanel track:@"Today_Notifications_listClick" properties:logInDic];
      NHNotificationsModel *model=SecOne_arrayData[indexPath.row];
      NotificationsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(model.read==NO){
            //未读变已读
            cell.red_image.backgroundColor=[UIColor clearColor];
            model.read = YES;
            [self push_message_mark:model.id];
        }
        [self PushVCType:model];//跳转逻辑判断
    } else if(1 == section){
        //BOOK or Reservation
        if (SecTwo_arrayData.count>0)
        {
            //Push To ReservationsDetiail!!!
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            NHReservationsDetailViewController* DetailVC=(NHReservationsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationsDetailViewController" andParent:self];
            [DetailVC setHidesBottomBarWhenPushed:YES];
            NHReservationOrdersListModel *model=SecTwo_arrayData[indexPath.row];
            DetailVC.Reservation_id=model.id;
//            //订单详情 取消后刷新
//            @weakify(self)
//            [DetailVC setPopDVCBack:^{
//                @strongify(self)
//                [self loadDate];
//            }];
        }
        else
        {
//            NSLog(@"Push To BOOK!!!没有预定内容");
        }
    } else {
        if (_SecThree_arrayData.count > 0) {
            // 跳转到活动详情页面
            [mixPanel track:@"Today_upcomingEvents_listClick" properties:logInDic];
            ((NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self]).eventsId = _SecThree_arrayData[indexPath.row].eventsId;
            
//            NakedEventsDetailViewController *eventsDetailViewController = (NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self];
//            eventsDetailViewController.eventsId = _SecThree_arrayData[indexPath.row].eventsId;
//            eventsDetailViewController.isRefresh = YES;
//            NakedEventsModel *eventsModel = _SecThree_arrayData[indexPath.row];
//            
//            @weakify(self)
//            [eventsDetailViewController setPopBack:^(NSInteger modelEventsId) {
//                @strongify(self)
//                if (eventsModel.eventsId == modelEventsId)
//                {
//                    [self.SecThree_arrayData removeObjectAtIndex:indexPath.row];
//                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                }
//                
//            }];
//            [eventsDetailViewController setPopRecommendBack:^{
//                [self.todayTableView reloadData];
//            }];
        }
    }
}

//跳转逻辑判断
-(void)PushVCType:(NHNotificationsModel *)model{
    //跳转用户动态
    if ([model.pushSign isEqualToString:@"FEED_COMMENT"]||[model.pushSign isEqualToString:@"FEED_LIKE"]||[model.pushSign isEqualToString:@"FEED_FOLLOWER_POST"]||[model.pushSign isEqualToString:@"COMMENT_LIKE"]) {
        
        NakedHubFeedDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController"];
        
        //判断是否要跳转
        if(model.skip){
            if (model.skipModelId==0) {
                //                NSLog(@"取消点赞或者取消了预定的情况下不跳转");
            }else{
                DetailVC.feedModelId=model.skipModelId;
                [DetailVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:DetailVC animated:YES];
            }
        }
        
    }
    //推送跳转到用户详情
    else if ([model.pushSign isEqualToString:@"USER_FOLLOW"]){
        
        NakedPerSonalDetailsViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController"];
        
        //判断是否跳转
        if (model.skip) {
            NakedUserModel *userM=[[NakedUserModel alloc]init];
            userM.userId=model.skipModelId;
            DetailVC.userModel=userM;
            [DetailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:DetailVC animated:YES];
        }
    }
    //推送跳转到预定记录详情
    else if ([model.pushSign isEqualToString:@"RESERVATION_CONFIRM"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_CONFIRM_START"]||[model.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_START"]||[model.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_UPCOMING"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_UPCOMING"]||[model.pushSign isEqualToString:@"RESERVATION_WORKSPACE_START"]){
        //USER_MEMBERSHIP_EXPIRING
        NHReservationsDetailViewController* DetailVC = [Utility GetViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationsDetailViewController"];
        
        //判断是否要跳
        if(model.skip){
            DetailVC.Reservation_id=model.skipModelId;
            [DetailVC setHidesBottomBarWhenPushed:YES];
            //订单列表 取消后刷新
            @weakify(self)
            [DetailVC setPopDVCBack:^{
                @strongify(self)
                [self loadDate];
            }];
            [mixPanel track:@"Today_upcomingReservations_listClick" properties:logInDic];
            [self.navigationController pushViewController:DetailVC animated:YES];
        }
    }
    else{
        NSLog(@"未找到对应跳转界面");
    }

}
//add footer tap_action
-(void)Footer_tap_Notifications:(UIView *)tap_view{
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]init];
    [tapg addTarget:self action:@selector(sj_tap1:)];
    tapg.numberOfTapsRequired=1;
    [tap_view setUserInteractionEnabled:YES];
    [tap_view addGestureRecognizer:tapg];
}
-(void)Footer_tap_booking:(UIView *)tap_view{
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]init];
    [tapg addTarget:self action:@selector(sj_tap2:)];
    tapg.numberOfTapsRequired=1;
    [tap_view setUserInteractionEnabled:YES];
    [tap_view addGestureRecognizer:tapg];
}

- (void)footerTapGestureRecognizer:(UIView *)tapView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(sj_tap3:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [tapView setUserInteractionEnabled:YES];
    [tapView addGestureRecognizer:tapGestureRecognizer];
}

//Footer action ***
- (void)sj_tap1:(UIGestureRecognizer*)sender
{
    if (SecOne_arrayData.count==0) {
//   NSLog(@"目前没有消息可以跳转");
    }else{
        
//   NSLog(@"有消息可以跳转");
    [mixPanel track:@"Today_Notifications_moreUnread" properties:logInDic];
    
    NotificationsListTableViewController* test2obj=(NotificationsListTableViewController*)[Utility pushViewControllerWithStoryboard:@"Notifications" andViewController:@"NotificationsListTableViewController" andParent:self];
    [test2obj setHidesBottomBarWhenPushed:YES];
    test2obj.NotType_str=self.queryUnits_str;//传递类型
    [Utility BadgeNumChanged:NO withBadgeNum:@"Read_All"];
    //二级界面消息列表 返回后 刷新today的消息列表数据
    @weakify(self)
    [test2obj setReadBOOL:^(NSArray *arrayData) {
        @strongify(self)
//        SecOne_arrayData=arrayData;
        [self loadDate];
    }];
    
        
    }
    
}
- (void)sj_tap2:(UIGestureRecognizer*)sender
{
    //显示全部订单
    if (SecTwo_arrayData.count>0) {

        NHReservationListViewController* test2obj=(NHReservationListViewController*)[Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationListViewController" andParent:self];
        //订单列表里 单个／多个 取消后刷新
        @weakify(self)
        [test2obj setPopddsBack:^(NSArray *chacel_arr) {
            @strongify(self)
            SecTwo_arrayData=chacel_arr;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.todayTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

        }];
        test2obj.NotType_str=self.queryUnits_str;//传递类型
        [test2obj setHidesBottomBarWhenPushed:YES];
        [mixPanel track:@"Today_upcomingReservations_viewAll" properties:logInDic];

    }
    //没有订单 需要预定
    else{
        NakedBookRoomViewController* BooKRoomVC =(NakedBookRoomViewController*)[Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedBookRoomViewController" andParent:self];
        [BooKRoomVC setHidesBottomBarWhenPushed:YES];
        [mixPanel track:@"Today_upcomingReservations_bookNow" properties:logInDic];

    }
}

- (void)sj_tap3:(UIGestureRecognizer*)sender
{
    if (_SecThree_arrayData.count > 0) {
        // 查看所有即将到来的活动页面
        [mixPanel track:@"Today_upcomingEvents_showMore" properties:logInDic];
        TodayRecommendEventsViewController *recommednEventsViewController = (TodayRecommendEventsViewController *)[Utility pushViewControllerWithStoryboard:@"TodayList" andViewController:@"TodayRecommendEventsViewController" andParent:self];
        recommednEventsViewController.queryUnit = self.queryUnits_str;
        
        @weakify(self)
        [recommednEventsViewController setPopTodayBack:^(NSMutableArray *recommendEvents) {
            @strongify(self)
            _SecThree_arrayData = recommendEvents;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.todayTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    } else {
        // 活动页面
        [mixPanel track:@"Today_events_showMore" properties:logInDic];
        [Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsViewController" andParent:self];
    }
}

@end

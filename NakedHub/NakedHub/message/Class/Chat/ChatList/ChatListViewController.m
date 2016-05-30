/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "RobotChatViewController.h"
#import "HttpRequest.h"
#import "NakedUserModel.h"
#import "NakedHubGroupModel.h"

#import "NakedChatListCell.h"
#import "NakedHubSendMsgViewController.h"


#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>
//#import "UITableView+EmptyDataSet.h"

@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.chatter];
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
           return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}

@end

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,ChatViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) EMSearchDisplayController *searchController;


@property (nonatomic,strong) NSMutableArray *userModels;
@property (nonatomic,strong) NSMutableArray *groupModels;

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}
- (IBAction)newMessage:(UIBarButtonItem *)sender {
    
    
}

- (void)viewDidLoad
{
    
//    self.title = @"MESSAGES";
    
//    self.navigationController.navigationBar.topItem.title = [GDLocalizableClass getStringForKey:@"MESSAGES"];
//    
//    self.navigationController.tabBarItem.title = [GDLocalizableClass getStringForKey:@"MESSAGES"];
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    
    [super viewDidLoad];
    
//    [self networkStateView];
//    [self searchController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSource];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [Utility getTopViewController:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[NakedChatListCell class] forCellReuseIdentifier:@"NakedChatListCell"];
    }
    
    return _tableView;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = [GDLocalizableClass getStringForKey:@"network.disconnection"];
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSMutableArray *conversations = [NSMutableArray arrayWithArray:[[EaseMob sharedInstance].chatManager conversations]];

    
    for (int i = 0; i<conversations.count; i++) {
        EMConversation *obj = conversations[i];
        if ([obj loadAllMessages].count<=0) {
            [conversations removeObject:obj];
        }
    }
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
           ^(EMConversation *obj1, EMConversation* obj2){
               EMMessage *message1 = [obj1 latestMessage];
               EMMessage *message2 = [obj2 latestMessage];
               if(message1.timestamp > message2.timestamp) {
                   return(NSComparisonResult)NSOrderedAscending;
               }else {
                   return(NSComparisonResult)NSOrderedDescending;
               }
           }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
        
//        ret = [Utility getHourMinuteWithInt:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = [GDLocalizableClass getStringForKey:@"message.image1"];
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = [GDLocalizableClass getStringForKey:@"message.voice1"];
            } break;
            case eMessageBodyType_Location: {
                ret = [GDLocalizableClass getStringForKey:@"message.location1"];
            } break;
            case eMessageBodyType_Video: {
                ret = [GDLocalizableClass getStringForKey:@"message.video1"];
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"NakedChatListCell";
    NakedChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[NakedChatListCell alloc] init];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    cell.nameLabel.text = conversation.chatter;
    
    
    if (conversation.conversationType == eConversationTypeChat) {
        cell.HeadPortraitView.image = [UIImage imageNamed:@"userIcon"];
        [cell.imageView setHidden:NO];
        
        [_userModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        
        [_userModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (((NakedUserModel*)obj).userId == [conversation.chatter integerValue]) {
                cell.nameLabel.text = ((NakedUserModel*)obj).nickname;
                [cell.HeadPortraitView sd_setImageWithURL:[NSURL URLWithString:((NakedUserModel*)obj).portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
                *stop = true;
            }
        }];
    }
    else{
        cell.nameLabel.text = [conversation.ext objectForKey:@"groupSubject"];
        
        [_groupModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NakedHubGroupModel*)obj).huanxinGroupId isEqualToString:conversation.chatter]) {
                [cell.HeadPortraitView sd_setImageWithURL:[NSURL URLWithString:((NakedHubGroupModel*)obj).logo] placeholderImage:[UIImage imageNamed: [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"chatGroupIcon" : @"chatGroupIcon"]];
                cell.nameLabel.text = ((NakedHubGroupModel*)obj).name;
                [cell.imageView setHidden:YES];
                *stop = true;
            }
        }];
    }
    cell.msgLabel.text = [self subTitleMessageByConversation:conversation];
    cell.timeLabel.text = [self lastMessageTimeByConversation:conversation];
    cell.promptPointView.hidden = [self unreadMessageCountByConversation:conversation]==0;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [mixPanel track:@"Message_listClick" properties:logInDic];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    __block NSString *title = conversation.chatter;
    
    __block NSString *HeadPortrait;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }
        else
        {
//            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (NakedHubGroupModel *group in _groupModels) {
                if ([group.huanxinGroupId isEqualToString:conversation.chatter]) {
                    HeadPortrait = group.logo;
                    title = group.name;
                    break;
                }
            }
        }
    } else if (conversation.conversationType == eConversationTypeChat) {
        
        [_userModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (((NakedUserModel*)obj).userId == [conversation.chatter integerValue]) {
                title = ((NakedUserModel*)obj).nickname;
                HeadPortrait = ((NakedUserModel*)obj).portait;
                *stop = true;
            }
        }];
    }
    
    NSString *chatter = conversation.chatter;
    if ([[RobotManager sharedInstance] isRobotWithUsername:chatter]) {
        chatController = [[RobotChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:chatter];
    }else {
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        chatController.title = title;
    }
    chatController.HeadPortrait = HeadPortrait;
    chatController.delelgate = self;
    [chatController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [GDLocalizableClass getStringForKey:@"Delete"];

}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchController.resultsSource removeAllObjects];
    
    NSMutableArray *tempArrs = [NSMutableArray array];
    [self.groupModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([((NakedHubGroupModel*)obj).name rangeOfString:searchText].location!=NSNotFound) {
            [tempArrs addObject:obj];
        }
    }];
    [self.userModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([((GYUserModel*)obj).username rangeOfString:searchText].location!=NSNotFound||[((GYUserModel*)obj).ext.remarkName rangeOfString:searchText].location!=NSNotFound) {
//            [tempArrs addObject:obj];
//        }
    }];
    [tempArrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NakedUserModel class]]) {
            NakedUserModel *userModel = (NakedUserModel*)obj;
            for ( EMConversation *conversation in self.dataSource) {
//                if ([conversation.chatter integerValue]==userModel.id) {
//                    [self.searchController.resultsSource addObject:conversation];
//                }
            }
        }
        else
        {
            NakedHubGroupModel *groupModel = (NakedHubGroupModel*)obj;
            for ( EMConversation *conversation in self.dataSource) {
                if ([conversation.chatter isEqualToString:groupModel.huanxinGroupId]) {
                    [self.searchController.resultsSource addObject:conversation];
                }
            }
        }
    }];
    [self.searchController.searchResultsTableView reloadData];

    
    
//    __weak typeof(self) weakSelf = self;
//    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
//        if (results) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.searchController.resultsSource removeAllObjects];
//                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
//                [weakSelf.searchController.searchResultsTableView reloadData];
//            });
//        }
//    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void) loadUsersWithChatIds:(NSMutableArray*)chaters
{
    NSString *userIds = @"";
    NSString *groupIds= @"";

    if (chaters.count>0) {
        
        for (EMConversation *converation in chaters) {
            if (converation.conversationType==eConversationTypeChat) {
                if (userIds.length<=0) {
                    userIds = converation.chatter;
                }
                else
                {
                    userIds = [userIds stringByAppendingString:[NSString stringWithFormat:@",%@",converation.chatter]];
                }
            }
            else
            {
                if (groupIds.length<=0) {
                    groupIds = converation.chatter;
                }
                else
                {
                    groupIds = [groupIds stringByAppendingString:[NSString stringWithFormat:@",%@",converation.chatter]];
                }
            }
        }
    }
    [HttpRequest getWithUrl:chat_chatList andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"userId":userIds,@"huanxinGroupId":groupIds}] andBlock:^(id response, NSError *error) {
        if (!error) {
            if (response[@"result"][@"chatGroups"]) {
                _groupModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedHubGroupModel class] fromJSONArray:response[@"result"][@"chatGroups"] error:nil]];
            }
            if (response[@"result"][@"users"]) {
                _userModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"][@"users"] error:nil]];
            }
            [_tableView reloadData];
        }
    }];
    
    
    
    
   /* if (userIds.length>0&&groupIds.length>0) {
        [HttpRequest getWithUrl:chat_users andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"userId":userIds}] andBlock:^(id response, NSError *error) {
            if (!error) {
                _userModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"] error:nil]];
                if (groupIds.length>0) {
                    [HttpRequest getWithUrl:chat_chatGroups andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"huanxinGroupId":groupIds}] andBlock:^(id response, NSError *error) {
                        if (!error) {
                            _groupModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedHubGroupModel class] fromJSONArray:response[@"result"] error:nil]];
//                            if ([Utility isOldDevices]) {
//                                [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
//                            }
//                            else
//                            {
                                [_tableView reloadData];
//                            }
                        }
                    }];
                }
            }
        }];
    }
    else if (groupIds.length>0&&userIds.length<=0) {
        [HttpRequest getWithUrl:chat_chatGroups andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"chatGroupId":groupIds}] andBlock:^(id response, NSError *error) {
            if (!error) {
                _groupModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedHubGroupModel class] fromJSONArray:response[@"result"] error:nil]];

//                if ([Utility isOldDevices]) {
//                    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
//                }
//                else
//                {
                    [_tableView reloadData];
//                }
            }
        }];
    }
    else if (userIds.length>0&&groupIds.length<=0) {
        [HttpRequest getWithUrl:chat_users andViewContoller:self andHudMsg:nil andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"userId":userIds}] andBlock:^(id response, NSError *error) {
            if (!error) {
                _userModels = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[NakedUserModel class] fromJSONArray:response[@"result"] error:nil]];
//                if ([Utility isOldDevices]) {
//                    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
//                }
//                else
//                {
                    [_tableView reloadData];
//                }
            }
        }];
    }*/
}


-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
//    [self loadData];
    
    [self loadUsersWithChatIds:self.dataSource];
    
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     [((NakedHubSendMsgViewController*)[segue destinationViewController]) setSendMsgSuccessCallBack:^(id objc) {
        ChatViewController *chatController ;
         if ([objc isKindOfClass:[NakedUserModel class]]) {
             chatController = [[ChatViewController alloc] initWithChatter:@(((NakedUserModel*)objc).userId).stringValue
                                                         conversationType:eConversationTypeChat];
             chatController.title = ((NakedUserModel*)objc).nickname;
             chatController.HeadPortrait = ((NakedUserModel*)objc).portait;
         }
         else
         {
             chatController = [[ChatViewController alloc] initWithChatter:((NakedHubGroupModel*)objc).huanxinGroupId
                                                         conversationType:eConversationTypeGroupChat];
             chatController.title = ((NakedHubGroupModel*)objc).name;
             chatController.HeadPortrait = ((NakedHubGroupModel*)objc).logo;
         }
         chatController.delelgate = self;
         [chatController setHidesBottomBarWhenPushed:YES];
         [self.navigationController pushViewController:chatController animated:YES];
         
         [mixPanel track:@"Message_newMessage" properties:logInDic];
     }];
     
 }



#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]integerValue] == [chatter integerValue]) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl];
    }
    for (NakedUserModel* user in _userModels) {
        if (user.userId == [chatter integerValue]) {
            return user.portait;
        }
    }
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    for (NakedUserModel* user in _userModels) {
        if (user.userId == [chatter integerValue]) {
            return user.nickname;
        }
    }
    return chatter;
}

@end

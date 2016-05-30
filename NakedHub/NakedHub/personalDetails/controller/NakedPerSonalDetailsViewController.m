//
//  NakedPerSonalDetailsViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPerSonalDetailsViewController.h"
#import "UINavigationBar+Awesome.h"
#import "NakedCommentCell.h"
#import "NakedPerSonalTagListCell.h"
#import "NakedPerSonalTableHeadSecionView.h"
#import "NakedContactCell.h"
#import "NakedHubFeedCell.h"
#import "NakedWorkCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NakedEditPerSonalDetailsViewController.h"
#import "ChatViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "NakedHubFeedDetailsViewController.h"
#import "UITableView+Refreshing.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

#define NAVBAR_CHANGE_POINT 50

@interface NakedPerSonalDetailsViewController ()<UITableViewDelegate,ChatViewControllerDelegate>
{
    UIColor *ned_graycolor;
    UIColor *ned_orangecolor;
    CGFloat cellSkills; // skill 栏 cell 的高度
    CGFloat cellInterests; // interests 栏 cell 的高度
}
//@property (strong, nonatomic) IBOutlet UIView *headerSecionView;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NakedPerSonalTagListCell *cell;
@property (nonatomic,strong) NSArray *headSectionTitles;
@property (nonatomic,strong) NSArray *cellIdentifiers;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userPortraitView;
@property (weak, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel     *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel     *signLabel;
@property (weak, nonatomic) IBOutlet UILabel     *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel     *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *follerLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *feedList;
@property (nonatomic,strong) NakedUserModel *userDetails;
@property (nonatomic,strong) NSMutableArray *contacts;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (nonatomic,strong) NakedHubFeedModel *feedModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signLabelHeightConstraint;
@property (nonatomic,assign) long long serverTime;
@property (nonatomic,assign) BOOL oneSelf;
@end

@implementation NakedPerSonalDetailsViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)userIconTouch:(UITapGestureRecognizer *)sender {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    //#if TRY_AN_ANIMATED_GIF == 1
    imageInfo.imageURL = [NSURL URLWithString:_userDetails.portait];
    //#else
    //    imageInfo.image =  .image;
    //#endif
    imageInfo.referenceRect = _userPortraitView.frame;
    imageInfo.referenceView = _userPortraitView.superview;
    imageInfo.referenceContentMode = _userPortraitView.contentMode;
    imageInfo.referenceCornerRadius = _userPortraitView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)perSonalDetails
{
    @weakify(self)
    [HttpRequest getWithUrl:user_detail andViewContoller:self andHudMsg:@"" andAttributes:_isMy?nil:[NSMutableDictionary dictionaryWithDictionary:@{@"userId":@(_userModel.userId)}] andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            NSError *error1 = nil;
            self.userDetails = [MTLJSONAdapter modelOfClass:[NakedUserModel class] fromJSONDictionary:response[@"result"] error:&error1];
            if (error1) {
                NSLog(@"%@",error1);
            }
            self.feedModel = [MTLJSONAdapter modelOfClass:[NakedHubFeedModel class] fromJSONDictionary:response[@"result"][@"ext"][@"feed"] error:nil];
            self.oneSelf = [response[@"result"][@"ext"][@"oneself"]boolValue];
            
            if (self.oneSelf) {
                if (self.userDetails.hub) {
                    [[NSUserDefaults standardUserDefaults]setObject:@(self.userDetails.hub.hubId) forKey:@"hubID"];
                    [[NSUserDefaults standardUserDefaults]setObject:self.userDetails.hub.address forKey:@"hubaddress"];
                    [[NSUserDefaults standardUserDefaults]setObject:self.userDetails.hub.name forKey:@"hubname"];
                    [[NSUserDefaults standardUserDefaults]setObject:self.userDetails.hub.picture forKey:@"hubpicture"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            
            [self configPerSonalDetailsHeaderView];
            _contacts = [NSMutableArray array];
            if (_userDetails.contact.facebook&&_userDetails.contact.facebook.length>0) {
                [_contacts addObject:@{@"content":_userDetails.contact.facebook,@"image":@"socialFacebook"}];
            }
            if (_userDetails.contact.twitter&&_userDetails.contact.twitter.length>0) {
                [_contacts addObject:@{@"content":_userDetails.contact.twitter,@"image":@"socialTwitter"}];
            }
            if (_userDetails.contact.wechat&&_userDetails.contact.wechat.length>0) {
                [_contacts addObject:@{@"content":_userDetails.contact.wechat,@"image":@"socialWechat"}];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void)configPerSonalDetailsHeaderView
{
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_userDetails.background] placeholderImage:[UIImage imageNamed:@"userbackGroup"]];
    [_userPortraitView sd_setImageWithURL:[NSURL URLWithString:_userDetails.portait] placeholderImage:[UIImage imageNamed:@"bigUserIcon"]];
    _userNameLabel.text = _userDetails.nickname;
    _positionLabel.text = _userDetails.title;
    _companyLabel.text = _userDetails.company.name;
    _signLabel.text = _userDetails.userDescription;
    _followersCountLabel.text = @(_userDetails.followers).stringValue;
    _followingCountLabel.text = @(_userDetails.following).stringValue;
    
    if (_oneSelf) {
        _followBtn.enabled = NO;
        _messageBtn.enabled = NO;
        [_followBtn setBackgroundColor:ned_graycolor];
        [_messageBtn setBackgroundColor:ned_graycolor];
    }else{
        [_followBtn setBackgroundColor:_userDetails.followed?ned_graycolor:ned_orangecolor];
        [_messageBtn setBackgroundColor:ned_orangecolor];
    }
    
    [_followBtn setTitle:_userDetails.followed?
     [GDLocalizableClass getStringForKey:@"FOLLOWING"]:
     [GDLocalizableClass getStringForKey:@"FOLLOW"] forState:UIControlStateNormal];
    if (!_oneSelf) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (_signLabel.text<=0) {
        _signLabelHeightConstraint.constant = 0;
    }
    [_tableHeaderView setNeedsUpdateConstraints];
    [_tableHeaderView updateConstraintsIfNeeded];
    [_tableHeaderView setNeedsLayout];
    [_tableHeaderView layoutIfNeeded];
    
    _userPortraitView.userInteractionEnabled = _userDetails.portait?YES:NO;
    
    CGRect rect = _tableHeaderView.frame;
    rect.size.height = _userPortraitView.frame.size.height+_userNameLabel.frame.size.height+_positionLabel.frame.size.height+_companyLabel.frame.size.height+_signLabel.frame.size.height+_followersCountLabel.frame.size.height+_followBtn.frame.size.height+182;
    
    if (_signLabel.text<=0) {
        rect.size.height -=20;
    }
    _tableHeaderView.frame = rect;
    [_tableView setTableHeaderView:_tableHeaderView];
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_userDetails.background] placeholderImage:[UIImage imageNamed:@"userbackGroup"]];
    [_userPortraitView sd_setImageWithURL:[NSURL URLWithString:_userDetails.portait] placeholderImage:[UIImage imageNamed:@"bigUserIcon"]];
}
- (void)loadFeedList
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(5)}];
    if (self.userModel) {
        [attr setObject:@(self.userModel.userId) forKey:@"userId"];
    }
    if (self.serverTime&&self.page!=1) {
        [attr setObject:@(self.serverTime) forKey:@"serverTime"];
    }
    [HttpRequest getWithUrl:feed_userFeeds andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
        NSArray *tempArr = [NSArray array];
        if (!error) {
            NSError *error1 =nil;
            tempArr = [MTLJSONAdapter modelsOfClass:[NakedHubFeedModel class] fromJSONArray:response[@"result"] error:&error1];
            NSLog(@"error = %@",error1);
            if (self.page == 1) {
                self.serverTime = [response[@"serverTime"]longLongValue];
                self.feedList = [NSMutableArray arrayWithArray:tempArr];
            }
            else
            {
                [self.feedList addObjectsFromArray:tempArr];
            }
        }
        [self.tableView endTableViewRefreshing:self.page == 1 andisHiddenFooter:tempArr.count<5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back:) name:@"removeData" object:nil];
    self.page = 1;
    [self perSonalDetails];
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else{
            self.page++;
        }
        [self loadFeedList];
    }];
    self.tableView.header.hidden = YES;
    [self loadFeedList];
    
    
    
    ned_graycolor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:223.0/255.0 alpha:1.0];
    ned_orangecolor=[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0];
    [self.followingLabel setText:[GDLocalizableClass getStringForKey:@"FOLLOWING"]];
    [self.follerLabel setText:[GDLocalizableClass getStringForKey:@"FOLLOWERS"]];
    [self.messageBtn setTitle:[GDLocalizableClass getStringForKey:@"MESSAGE"] forState:UIControlStateNormal];
    
    _headSectionTitles = @[[GDLocalizableClass getStringForKey:@"SKILLS"] ,
                           [GDLocalizableClass getStringForKey:@"INTERESTS"],
                            [GDLocalizableClass getStringForKey:@"CONTACT"],[GDLocalizableClass getStringForKey:@"WORK"],[GDLocalizableClass getStringForKey:@"FEED & COMMUNITY"]];
    _cellIdentifiers = @[@"NakedPerSonalTagListCell",@"NakedPerSonalTagListCell",@"NakedContactCell",@"NakedWorkCell",@"NakedHubFeedCell"];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Utility configSubView:_followBtn CornerWithRadius:6.0];
    [Utility configSubView:_messageBtn CornerWithRadius:6.0];
    [Utility configSubView:_userPortraitView CornerWithRadius:_userPortraitView.frame.size.width/2];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            if (_userDetails.skills&&_userDetails.skills.length>0) {
                return 1;
            }
        }
            break;
        case 1:
        {
            if (_userDetails.interests&&_userDetails.interests.length>0) {
                return 1;
            }
        }
            break;
        case 2:
        {
            return _contacts.count;
        }
            break;
        case 3:
        {
            if (!_userDetails.company) {
                return 0;
            }
            return 1;
        }
            break;
        case 4:
        {
            return self.feedList.count;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0||indexPath.section == 1) {
        NakedPerSonalTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" forIndexPath:indexPath];
        cell.isSkills = indexPath.section == 0;
        if (indexPath.section == 0) {
            if (_userDetails.skills.length>0) {
                cell.dataList = [_userDetails.skills componentsSeparatedByString:@","];
            }
        }
        if (indexPath.section == 1) {
            if (_userDetails.interests.length>0)
            {
                cell.dataList = [_userDetails.interests componentsSeparatedByString:@","];
            }
        }
//        [cell.collectionView reloadData];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NakedContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedContactCell" forIndexPath:indexPath];
        cell.contactImageView.image = [UIImage imageNamed:_contacts[indexPath.row][@"image"]];
        cell.contactTitleLabel.text = _contacts[indexPath.row][@"content"];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        NakedWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedWorkCell" forIndexPath:indexPath];
        [cell setCompaniesDM:_userDetails.company];
        return cell;
    }
    else
    {
        NakedHubFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubFeedCell" forIndexPath:indexPath];
        if (_feedList.count>0) {
            cell.feedModel = _feedList[indexPath.row];
        }
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (!_userDetails.skills || _userDetails.skills.length<=0) {
                return nil;
            }
        }
            break;
        case 1:
        {
            if (!_userDetails.interests || _userDetails.interests.length<=0) {
                return nil;
            }
        }
            break;
        case 2:
        {
            if (_contacts.count<=0) {
                return nil;
            }
        }
            break;
        case 3:
        {
            if (!_userDetails.company) {
                return nil;
            }
        }
            break;
        case 4:
        {
            if (_feedList.count==0) {
                return nil;
            }
        }
            break;
        default:
            break;
    }
    
    NakedPerSonalTableHeadSecionView *headView = [[NakedPerSonalTableHeadSecionView alloc]init];
    headView.titleLabel.text = _headSectionTitles[section];
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (!_userDetails.skills || _userDetails.skills.length<=0) {
                return 0;
            }
        }
            break;
        case 1:
        {
            if (!_userDetails.interests || _userDetails.interests.length<=0) {
                return 0;
            }
        }
            break;
        case 2:
        {
            if (_contacts.count<=0) {
                return 0;
            }
        }
            break;
        case 3:
        {
            if (!_userDetails.company) {
                return 0;
            }
        }
            break;
        case 4:
        {
            if (_feedList.count==0) {
                return 0;
            }
        }
            break;
        default:
            break;
    }
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>1) {
        return [tableView fd_heightForCellWithIdentifier:_cellIdentifiers[indexPath.section] cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
            if ([cell isKindOfClass:[NakedHubFeedCell class]]) {
                if (_feedList.count>0) {
                    ((NakedHubFeedCell *)cell).feedModel = _feedList[indexPath.row];
                }
            }
            if ([cell isKindOfClass:[NakedContactCell class]]) {
                ((NakedContactCell*)cell).contactImageView.image = [UIImage imageNamed:_contacts[indexPath.row][@"image"]];
                ((NakedContactCell*)cell).contactTitleLabel.text = _contacts[indexPath.row][@"content"];
            }
        }];
    }
    else
    {
//        if (cellSkills && cellInterests) {
//            if (0 == indexPath.section) {
//                return cellSkills;
//            }
//            if (1 == indexPath.section) {
//                return cellInterests;
//            }
//        }
        _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" ];
        if (indexPath.section == 0) {
            if (_userDetails.skills.length>0) {
                _cell.dataList = [_userDetails.skills componentsSeparatedByString:@","];
            }
            cellSkills = _cell.collectionView.contentSize.height;
        }
        if (indexPath.section == 1) {
            if (_userDetails.interests.length>0)
            {
                _cell.dataList = [_userDetails.interests componentsSeparatedByString:@","];
            }
            cellInterests = _cell.collectionView.contentSize.height;
        }
        return _cell.collectionView.contentSize.height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==3) {
        //companylistVC->companyVC
        NHCompanyDetailsViewController* company = (NHCompanyDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self];
        company.Details_ID = _userDetails.company.id;
    }
    if (indexPath.section==4) {
        NakedHubFeedDetailsViewController *FeedDetailsVC =(NakedHubFeedDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController" andParent:self];
        FeedDetailsVC.feedModel = _feedList[indexPath.row];
        [mixPanel track:@"Feed_comment" properties:logInDic];
        [FeedDetailsVC setLikeCallBack:^(NakedHubFeedModel *feedModel){
            _feedList[self.tableView.indexPathForSelectedRow.row] = feedModel;
            [self.tableView reloadData];
        }];
        [FeedDetailsVC setCommentsCallBack:^(NakedHubFeedModel *feedModel){
            _feedList[self.tableView.indexPathForSelectedRow.row] = feedModel;
            [self.tableView reloadData];
        }];
    }
}
- (IBAction)followAction:(UIButton *)sender {
    [mixPanel track:@"User_follow" properties:logInDic];
    [HttpRequest postWithURLSession:user_follow andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"refId":@(_userModel.userId),@"type":@"USER2USER"}] andBlock:^(id response, NSError *error) {
        if (!error) {
            if (response[@"result"]) {
                _followersCountLabel.text = @([response[@"result"] integerValue]).stringValue;
                _userDetails.followed = !_userDetails.followed;
                [_followBtn setBackgroundColor:_userDetails.followed?ned_graycolor:ned_orangecolor];
                
                [_followBtn setTitle:_userDetails.followed?[GDLocalizableClass getStringForKey:@"FOLLOWING"]:[GDLocalizableClass getStringForKey:@"FOLLOW"]
                            forState:UIControlStateNormal];
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
}
- (IBAction)messageAction:(UIButton *)sender {
    [mixPanel track:@"User_message" properties:logInDic];
   ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:@(_userDetails.userId).stringValue
                                                conversationType:eConversationTypeChat];
    chatController.title = _userDetails.nickname;
    chatController.HeadPortrait= _userDetails.portait;
    chatController.delelgate = self;
    [chatController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatController animated:YES];
}
#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kUserIdName]integerValue] == [chatter integerValue]) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl];
    }
    return _userDetails.portait;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    
    return _userDetails.nickname;
}



#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
{
    return _oneSelf;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [mixPanel track:@"User_edit" properties:logInDic];
    ((NakedEditPerSonalDetailsViewController*)segue.destinationViewController).userModel = _userDetails;
    @weakify(self)
    [((NakedEditPerSonalDetailsViewController*)segue.destinationViewController) setUpdateCallBack:^{
       @strongify(self)
        [self perSonalDetails];
    }];
}


@end

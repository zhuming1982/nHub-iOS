//
//  NHCompanyDetailsViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHEditCompanyDetailsViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "UINavigationBar+Awesome.h"
#import "NakedCommentCell.h"
#import "NakedPerSonalTagListCell.h"
#import "NakedPerSonalTableHeadSecionView.h"
#import "NakedContactCell.h"
#import "NakedHubFeedCell.h"
#import "NakedWorkCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ExporeServicecellTableViewCell.h"
#import "Constant.h"

#import "NHCompaniesDetailsModel.h"
#import "HttpRequest.h"
#import "UITableView+Refreshing.h"
#import "UIImageView+WebCache.h"
#import "NHEditCompanyDetailsViewController.h"
#import "NakedPerSonalDetailsViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

#define NAVBAR_CHANGE_POINT 50


@interface NHCompanyDetailsViewController ()<UITableViewDelegate>
{
    UIColor *ned_orangecolor;
    UIColor * ned_graycolor;
}
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *backguroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *introduction_label;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NakedPerSonalTagListCell *cell;
@property (nonatomic,strong) NSArray *headSectionTitles;
@property (nonatomic,strong) NSArray<NSArray*> *cellIdentifiers;
//cell数据源
@property (nonatomic,strong) NHCompaniesDetailsModel *DetailData;//详情
@property (nonatomic,strong) NSMutableArray *service_name;

//@property (nonatomic,strong) NSMutableArray *team_arr;//team array

@property (nonatomic,strong) NakedUserModel *userDetails;
@property (nonatomic,strong) NSMutableArray *Arr_contact;//联系
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionHeightConstraint;


@end

@implementation NHCompanyDetailsViewController
@synthesize Details_ID,DetailData,Arr_contact,service_name,Follower_number,isFollow,Follow_BTN_outlet,nav_RIGHT_BTN;

//@synthesize currentTag;


- (IBAction)back:(UIBarButtonItem *)sender {
    if (_PopBack) {
        _PopBack();
    }
    if (_FollowBOOL) {
        _FollowBOOL(DetailData.followed);
    }
    if (_PopName) {
        _PopName(DetailData.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidLayoutSubviews{
//    [Utility configSubView:_headPhotoImageView CornerWithRadius:_headPhotoImageView.frame.size.width/2];
    _headPhotoImageView.layer.masksToBounds=YES;
   _headPhotoImageView.layer.cornerRadius=_headPhotoImageView.frame.size.width/10.0f; //设置圆
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSLog(@"Details_ID=%ld",(long)Details_ID);
    ned_graycolor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:223.0/255.0 alpha:1.0];
    ned_orangecolor=[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0];
   
    [self.followersLabel setText:[GDLocalizableClass getStringForKey:@"FOLLOWERS"]];
   
    [self DetailsDatasource];

    //判断有没有服务
    _headSectionTitles=@[[GDLocalizableClass getStringForKey:@"CONTACT"] ,[GDLocalizableClass getStringForKey:@"SERVICES"],[GDLocalizableClass getStringForKey:@"TEAM"]];
    
    _cellIdentifiers=@[
                       @[@"NakedContactCell",@"NakedContactCell"],
                       @[@"NakedPerSonalTagListCell"],
                       @[@"ExporeServicecellTableViewCell"]
                       ];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headimageAction)];
    [_headPhotoImageView addGestureRecognizer:singleTap1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
}

-(void)headimageAction{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    //#if TRY_AN_ANIMATED_GIF == 1
    imageInfo.imageURL = [NSURL URLWithString:DetailData.logo];
    //#else
    //    imageInfo.image =  .image;
    //#endif
    imageInfo.referenceRect = _headPhotoImageView.frame;
    imageInfo.referenceView = _headPhotoImageView.superview;
    imageInfo.referenceContentMode = _headPhotoImageView.contentMode;
    imageInfo.referenceCornerRadius = _headPhotoImageView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

//加载数据源
-(void)DetailsDatasource{

    service_name=[[NSMutableArray alloc]init];
    Arr_contact=[[NSMutableArray alloc]init];
//    team_arr=[[NSMutableArray alloc]init];
    [HttpRequest getWithUrl:_isMy?company_myCompany:company_(Details_ID) andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            //Company'Detail
            if (![response[@"result"] isKindOfClass:[NSNull class]]) {
                DetailData = [MTLJSONAdapter modelOfClass:[NHCompaniesDetailsModel class] fromJSONDictionary:response[@"result"] error:nil];
                if (_isMy) {
                    Details_ID=DetailData.id;
                }
            }
            //头像点击放大
            if(DetailData.logo.length==0||DetailData.logo==nil||[DetailData.logo isKindOfClass:[NSNull class]]){
                _headPhotoImageView.userInteractionEnabled = NO;
            }else{
                _headPhotoImageView.userInteractionEnabled = YES;
            }

            //关注bool
            [Follow_BTN_outlet setTitle:DetailData.followed?[GDLocalizableClass getStringForKey:@"FOLLOWING"]:[GDLocalizableClass getStringForKey:@"FOLLOW"]
                               forState:UIControlStateNormal];
            [Follow_BTN_outlet setBackgroundColor:DetailData.followed?ned_graycolor:ned_orangecolor];
           
            //公司名字
            self.company_title.text=DetailData.name;
            self.Location_label.text=DetailData.address;
            //隐藏编辑按钮
                if(DetailData.isOwner){
                    [[self.navigationController.navigationBar.subviews objectAtIndex:2] setHidden:NO];
//                    self.Follow_BTN_outlet.userInteractionEnabled=NO;
                }else{
                    [[self.navigationController.navigationBar.subviews objectAtIndex:2] setHidden:YES];
//                    self.Follow_BTN_outlet.userInteractionEnabled=NO;
                }
            //背景＋头像logo
            [self.backguroundImageView sd_setImageWithURL: [NSURL URLWithString:DetailData.background] placeholderImage:[UIImage imageNamed:@"userbackGroup"]];
            [self.headPhotoImageView sd_setImageWithURL:[NSURL URLWithString:DetailData.logo] placeholderImage:[UIImage imageNamed:@"Company Profile"]];
            //Followers
            self.Follower_number.text=[NSString stringWithFormat:@"%li",(long)DetailData.followers];
            
            //介绍
            self.introduction_label.text=DetailData.introduction;
            //services
            for (ExporeServicesModel *servicesModel in DetailData.services) {
                if (servicesModel.name!=nil) {
                    [service_name addObject:servicesModel.name];
                }
            }
            //Contact
            if (DetailData.contact.facebook&&DetailData.contact.facebook.length>0) {
                if ([DetailData.contact.facebook isEqualToString:@""]) {
                }else{
                [Arr_contact addObject:DetailData.contact.facebook];
                }
            }
            if (DetailData.contact.twitter&&DetailData.contact.twitter.length>0) {
                if ([DetailData.contact.facebook isEqualToString:@""]) {
                }else{
                [Arr_contact addObject:DetailData.contact.twitter];
                }
            }
            if (DetailData.contact.wechat&&DetailData.contact.wechat.length>0) {
                if ([DetailData.contact.facebook isEqualToString:@""]) {
                }else{
                [Arr_contact addObject:DetailData.contact.wechat];
                }
            }
            
            if (_introduction_label.text.length<=0) {
                _introductionHeightConstraint.constant = 0;
            }
            
            //自适应公司介绍
            [_tableHeaderView setNeedsUpdateConstraints];
            [_tableHeaderView updateConstraintsIfNeeded];
            [_tableHeaderView setNeedsLayout];
            [_tableHeaderView layoutIfNeeded];
            CGRect rect = _tableHeaderView.frame;
            
            rect.size.height = _headPhotoImageView.frame.size.height+_company_title.frame.size.height+Follower_number.frame.size.height+_Location_label.frame.size.height+_followersLabel.frame.size.height+Follow_BTN_outlet.frame.size.height+_introduction_label.frame.size.height+20+2+20+20+20+20+64;
            
            if (_introduction_label.text.length<=0) {
                rect.size.height -= 20;
            }
            
            _tableHeaderView.frame = rect;
            [_tableView setTableHeaderView:_tableHeaderView];
        }
        
        [self.tableView reloadData];
    }];
    
    
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
        {
            return Arr_contact.count;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
             return DetailData.members.count;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        //CONTACT
        if (indexPath.section==0) {
            NakedContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedContactCell" forIndexPath:indexPath];
            cell.contactTitleLabel.text = Arr_contact[indexPath.row];
            //image
            NSMutableArray *contactimages = [NSMutableArray array];
            if (DetailData.contact.facebook) {
                [contactimages addObject:@"socialFacebook"];
            }
            if (DetailData.contact.twitter) {
                [contactimages addObject:@"socialTwitter"];
            }
            if (DetailData.contact.wechat) {
                [contactimages addObject:@"socialWechat"];
            }
            //        NSLog(@"=%@",contactimages);
            cell.contactImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",contactimages[indexPath.row]]];
            return cell;
        }
        //SERVICES
        else if (indexPath.section == 1)
        {
            NakedPerSonalTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" forIndexPath:indexPath];
            cell.isSkills=YES;
            if (cell.dataList.count != service_name.count) {
                cell.dataList=service_name;
                [cell.collectionView reloadData];
            }
            
            return cell;
        }
        else{
            ExporeServicecellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExporeServicecellTableViewCell" forIndexPath:indexPath];
//            NSLog(@"DetailData.members=%@",DetailData.members[indexPath.row]);
            cell.title_label.text=DetailData.members[indexPath.row].nickname;
            cell.members.text=DetailData.members[indexPath.row].title;
            
            
            [cell.left_iamge sd_setImageWithURL:[NSURL URLWithString:DetailData.members[indexPath.row].portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
            [Utility configSubView:cell.left_iamge CornerWithRadius:cell.left_iamge.frame.size.width/2];
            return cell;
        }

    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NakedPerSonalTableHeadSecionView *headView = [[NakedPerSonalTableHeadSecionView alloc]init];
    headView.titleLabel.text = _headSectionTitles[section];
    
    
    if(Arr_contact.count==0){
        if (section==0) {
            headView.titleLabel.text = @"";
        }
    }
    if(service_name.count==0){
        if (section==1) {
            headView.titleLabel.text = @"";
        }
    }
    if(DetailData.members.count==0){
        if (section==2) {
            headView.titleLabel.text = @"";
        }
    }

    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if(Arr_contact.count==0){
                return 0.1;
            }
        }
            break;
        case 1:
        {
            if (service_name.count==0) {
                return 0.1;
            }
        }
            break;
        case 2:
        {
            if(DetailData.members.count==0){
            return 0.1;
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
    switch (indexPath.section) {
        case 0:
        {
            return [tableView fd_heightForCellWithIdentifier:@"NakedContactCell" cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
                if ([cell isKindOfClass:[NakedContactCell class]]) {
                    ((NakedContactCell*)cell).contactTitleLabel.text = Arr_contact[indexPath.row];
                }
            }];
        }
            break;
        case 1:
        {
            if(service_name.count>0){
                //services
                if (_cell == nil)
                {
                    _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" ];
                }
                _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" ];
                _cell.dataList=service_name;
                return _cell.collectionView.contentSize.height;

            }
            else{
                return 0;
            }
        }
            break;
        case 2:
        {
            if(DetailData.members>0){
                return 94;
            }else{
            return 0;
            }
        }
            break;
            
            
        default:
            return 54;
            break;
    }
}

//didSelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"PersonalDetails" bundle:nil];
    NakedPerSonalDetailsViewController* PersonalDetails = [secondStoryBoard instantiateViewControllerWithIdentifier:@"NakedPerSonalDetailsViewController"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isKindOfClass:[ExporeServicecellTableViewCell class]]) {
        [mixPanel track:@"Company_userDetail" properties:logInDic];
        PersonalDetails.userModel = DetailData.members[indexPath.row];
        [self.navigationController pushViewController:PersonalDetails animated:YES];
    }
    
    
}



//个人设置
- (IBAction)Edit_Right_btn:(UIBarButtonItem *)sender {
    [mixPanel track:@"Company_edit" properties:logInDic];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CompanyDetails" bundle:nil];
    NHEditCompanyDetailsViewController* company = [secondStoryBoard instantiateViewControllerWithIdentifier:@"NHEditCompanyDetailsViewController"];
    company.isMy=_isMy;
    if(DetailData.isOwner){
        company.CompanyModel = DetailData;
        @weakify(self)
        [company setUpdateCallBack:^{
            @strongify(self)
            [self DetailsDatasource];
        }];
        
        if (_FollowBack) {
            _FollowBack();
        }
        [self.navigationController pushViewController:company animated:YES];
    }else{
        NSLog(@"不是你的公司！！！");
    }
}
//关注
- (IBAction)Follow_act:(UIButton *)sender {
    
    [mixPanel track:@"Company_follow" properties:logInDic];
    

    
    [HttpRequest postWithURLSession:user_follow andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"refId":@(Details_ID),@"type":@"USER2COMPANY"}] andBlock:^(id response, NSError *error) {
        if (!error) {
            if (response[@"result"]) {
                DetailData.followed = !DetailData.followed;
                [Follow_BTN_outlet setTitle:DetailData.followed?[GDLocalizableClass getStringForKey:@"FOLLOWING"] :[GDLocalizableClass getStringForKey:@"FOLLOW"]
                                   forState:UIControlStateNormal];
                [Follow_BTN_outlet setBackgroundColor:DetailData.followed?ned_graycolor:ned_orangecolor];
                //Followers 刷新
                [self DetailsDatasource];
                
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
    
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}



@end















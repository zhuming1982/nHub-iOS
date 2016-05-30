//
//  NakedHubFeedListViewController.m
//  NakedHub
//
//  Created by 朱明 on 16/3/10.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedHubFeedListViewController.h"
#import "UITableView+Refreshing.h"
#import "UIColor+extensions.h"
#import "NakedHubFeedCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NakedMenuCell.h"
#import "LMDropdownView.h"
#import "HttpRequest.h"
#import "NakedHubFeedModel.h"
#import "NakedHubPostFeedViewController.h"
#import "NakedHubFeedDetailsViewController.h"
#import "Constant.h"

#define COUNT 10

@interface NakedHubFeedListViewController ()<LMDropdownViewDelegate,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic,assign) long long serverTime;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (nonatomic,strong) NSArray<NakedHubModel*> *menuLocationTitles;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *feedList;
@property (nonatomic,strong) NakedHubModel *hubModel;
@property (weak, nonatomic) IBOutlet UIImageView *HeadPortraitView;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;

@property (weak, nonatomic) IBOutlet UILabel *typeMsgLabel;

@end

@implementation NakedHubFeedListViewController

- (IBAction)selectLocation:(UIButton *)sender {
    if (self.menuLocationTitles.count==0) {
        @weakify(self)
        [HttpRequest getWithUrl:hub_list andViewContoller:self andHudMsg:nil andAttributes:nil andBlock:^(id response, NSError *error) {
            if (!error) {
                @strongify(self)
                self.menuLocationTitles = [MTLJSONAdapter modelsOfClass:[NakedHubModel class] fromJSONArray:response[@"result"] error:nil];
                self.menuTableView.frame = CGRectMake(CGRectGetMinX(self.menuTableView.frame),CGRectGetMinY(self.menuTableView.frame),
                                                      CGRectGetWidth(self.view.bounds),
                                                      MIN(CGRectGetHeight(self.view.bounds) - 44, self.menuLocationTitles.count * 44+44));
                [self.menuTableView reloadData];
            }
            
        }];
    }
    [self showDropDownViewFromDirection:LMDropdownViewDirectionTop];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_HeadPortraitView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.dropdownView.isOpen) {
        [self.dropdownView hide];
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Utility configSubView:_HeadPortraitView CornerWithRadius:_HeadPortraitView.frame.size.height/2];
}

- (void)viewDidLoad {
   
//    self.tableView.estimatedRowHeight = 300;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
     [super viewDidLoad];
    
    
    
    [self.typeMsgLabel setText:[GDLocalizableClass getStringForKey:@"Type your message..."]];
    
     [_titleBtn setTitle:[GDLocalizableClass getStringForKey:@"All Locations"] forState:UIControlStateNormal];
    
    [_HeadPortraitView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    @weakify(self)
    [HttpRequest getWithUrl:hub_list andViewContoller:self andHudMsg:nil andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            self.menuLocationTitles = [MTLJSONAdapter modelsOfClass:[NakedHubModel class] fromJSONArray:response[@"result"] error:nil];
            self.menuTableView.frame = CGRectMake(CGRectGetMinX(self.menuTableView.frame),CGRectGetMinY(self.menuTableView.frame),
                                                  CGRectGetWidth(self.view.bounds),
                                                  MIN(CGRectGetHeight(self.view.bounds) - 44, self.menuLocationTitles.count * 44+44));
            [self.menuTableView reloadData];
        }
    }];
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else{
            self.page++;
        }
        
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
        if (self.hubModel) {
            [attr setObject:@(self.hubModel.hubId) forKey:@"hubId"];
        }
        if (self.serverTime&&!isPull) {
            [attr setObject:@(self.serverTime) forKey:@"serverTime"];
        }
        
        [HttpRequest getWithUrl:feed_list andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
            NSArray *tempArr = [NSArray array];
            if (!error) {
                NSError *error1 =nil;
                tempArr = [MTLJSONAdapter modelsOfClass:[NakedHubFeedModel class] fromJSONArray:response[@"result"] error:&error1];
                NSLog(@"error = %@",error1);
                if (isPull) {
                    self.serverTime = [response[@"serverTime"]longLongValue];
                    self.feedList = [NSMutableArray arrayWithArray:tempArr];
                }
                else
                {
                    [self.feedList addObjectsFromArray:tempArr];
                }
            }
            [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:tempArr.count<COUNT];
        }];
    }];
     [self.tableView.header beginRefreshing];
}


#pragma mark - DROPDOWN VIEW

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
                                                    withContentView:self.menuTableView];
                }];
                
                break;
            }
            default:
                break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.tag == 1000?_menuLocationTitles.count+1:self.feedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (tableView.tag == 1000) {
         if (indexPath.row == 0) {
             NakedMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedMenuCell" forIndexPath:indexPath];
             cell.titleLabel.text = [GDLocalizableClass getStringForKey:@"All Locations"];
             return cell;
         }
         if (_menuLocationTitles.count>0) {
             NakedMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedMenuCell" forIndexPath:indexPath];
             cell.titleLabel.text = _menuLocationTitles[indexPath.row-1].name;
             return cell;
         }
     }
    
     NakedHubFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubFeedCell" forIndexPath:indexPath];
    if (self.feedList.count) {
        cell.feedModel = self.feedList[indexPath.row];
    }
     @weakify(cell)
     [cell setClikeImageViewActionBlock:^(UIImageView *imageV) {
         @strongify(cell)
        [cell showHostImageView:cell.feedImageView andVC:self];
     }];
    
    [cell setClikeUserAvatarImageViewActionBlock:^(UIImageView *imgV) {
        @strongify(cell)
        [cell gotoUserDetailsVC:cell.feedModel.user andVC:self];
    }];
    
    [cell setActionClikeLinkBlock:^(NSURL *url) {
        @strongify(cell)
        [cell ClikeWithLink:url andController:self];
    }];
    
    [cell setRecognizeQRCodeCallBack:^{
        @strongify(cell)
        [cell ClikeWithLink:[NSURL URLWithString:cell.QRCodeResul] andController:self];
    }];
    
    
    [cell setButtonActionBlock:^(UIButton *sender) {
        @strongify(cell)
        switch (sender.tag) {
            case 99:{
                //like
                [cell likeClikeWithFeedModel:cell.feedModel andController:self and:nil];
            }
                break;
            case 100:
            {
                //comments
                [cell commentClikeWithFeedModel:cell.feedModel andController:self];
            }
                break;
            default:
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertC addAction:[UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Report"]  style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [cell ForWardClikeWithFeedModel:cell.feedModel andController:self];
                    [mixPanel track:@"Feed_report" properties:logInDic];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Cancel"]  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertC dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
            }
                break;
        }
    }];
    
    
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1000) {
        if (indexPath.row == 0) {
            [_titleBtn setTitle:[GDLocalizableClass getStringForKey:@"All Locations"] forState:UIControlStateNormal];
            self.hubModel = nil;
        }
        else
        {
            if (_menuLocationTitles.count>0) {
                [_titleBtn setTitle:_menuLocationTitles[indexPath.row-1].name forState:UIControlStateNormal];
                self.hubModel = _menuLocationTitles[indexPath.row-1];
            }
            
        }
        [self.dropdownView hide];
        [self.tableView.header beginRefreshing];
        
        [UIView animateWithDuration:0.1 animations:^{
          self.downImage.transform = CGAffineTransformIdentity; // All Location 箭头还原
        }];
    }
}

#pragma mark - LMDropdownViewDelegate
- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView{
    [UIView animateWithDuration:0.1 animations:^{
        self.downImage.transform = CGAffineTransformIdentity; // All Location 箭头还原
    }];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[NakedHubPostFeedViewController class]]) {
        [mixPanel track:@"Feed_post" properties:logInDic];
        
        [((NakedHubPostFeedViewController*)segue.destinationViewController) setPull:^{
            
            [self.navigationItem.backBarButtonItem setTitle:nil];
            [self.tableView.header beginRefreshing];
        }];
        
    if ([segue.identifier isEqualToString:@"FeedRightBar"] || [segue.identifier isEqualToString:@"FeedMessage"]) {
            [((NakedHubPostFeedViewController*)segue.destinationViewController) setIsPhoto:^BOOL() {
                return NO;
            }];
        }
        if ([segue.identifier isEqualToString:@"FeedPhoto"]) {
            [((NakedHubPostFeedViewController*)segue.destinationViewController) setIsPhoto:^BOOL() {
                return YES;
            }];
        }
    }
    else
    {
        NakedHubFeedDetailsViewController *FeedDetailsVC =((NakedHubFeedDetailsViewController*)segue.destinationViewController);
        FeedDetailsVC.feedModel = _feedList[self.tableView.indexPathForSelectedRow.row];
        [mixPanel track:@"Feed_comment" properties:logInDic];
        [FeedDetailsVC setLikeCallBack:^(NakedHubFeedModel *feed) {
            _feedList[self.tableView.indexPathForSelectedRow.row] = feed;
            [self.tableView reloadData];
        }];
        [FeedDetailsVC setCommentsCallBack:^(NakedHubFeedModel *feed){
            _feedList[self.tableView.indexPathForSelectedRow.row] = feed;
            [self.tableView reloadData];
        }];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        return 44;
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:@"NakedHubFeedCell" cacheByIndexPath:indexPath configuration:^(NakedHubFeedCell *cell) {
            if (self.feedList.count) {
                cell.feedModel = self.feedList[indexPath.row];
            }
        }];
    }
}

// 跳转到搜索页面
- (IBAction)pushSearch:(id)sender
{
    [mixPanel track:@"Feed_search" properties:logInDic];
    [Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewController" andParent:self];
}


@end

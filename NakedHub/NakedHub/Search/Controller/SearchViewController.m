//
//  SearchViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchModel.h"
#import "SearchNormalModel.h"
#import "NakedUserModel.h"
#import "NHCompaniesDetailsModel.h"
#import "NakedEventsModel.h"
#import "NakedHubFeedModel.h"

#import "SearchNormalCell.h"
#import "SearchMembersCell.h"
#import "SearchCompaniesCell.h"
#import "SearchEventsCell.h"
#import "SearchPostCell.h"

#import "SearchHeaderView.h"
#import "SearchFooterView.h"

#import "RecommendEventsViewController.h"
#import "SearchViewAllViewController.h"
#import "NakedPerSonalDetailsViewController.h"
#import "NHCompanyDetailsViewController.h"
#import "NakedEventsDetailViewController.h"
#import "NakedHubFeedDetailsViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface SearchViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSURLSessionDataTask *urlSessionDataTask;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) BOOL isSearch;

@property (nonatomic, strong) NSArray<SearchNormalModel *> *normalArray; // 默认搜索推荐

@property (nonatomic, strong) NSArray<SearchModel *> *searchArray;

@property (nonatomic, strong) NSArray<NakedUserModel *> *membersArray; // 成员
@property (nonatomic, copy) NSString *membersString;

@property (nonatomic, strong) NSArray<NHCompaniesDetailsModel *> *companiesArray; // 公司
@property (nonatomic, copy) NSString *companiesString;

@property (nonatomic, strong) NSArray<NakedEventsModel *> *eventsArray; // 活动
@property (nonatomic, copy) NSString *eventsString;

@property (nonatomic, strong) NSArray<NakedHubFeedModel *> *postsArray; // 帖子
@property (nonatomic, copy) NSString *postsString;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    if ([Utility isiPhone4] || [Utility isiPhone5] || [Utility isiPhone6])
    {
        /* iPhone 4 5 6 titleView 左边空 54, 右边空 8 */
        _textField.frame = CGRectMake(_textField.frame.origin.x, _textField.frame.origin.y, kScreenWidth - 54 - 8, _textField.frame.size.height);
    } else {
        /* iPhone 6P titleView 左边空 58, 右边空 12 */
        _textField.frame = CGRectMake(_textField.frame.origin.x, _textField.frame.origin.y, kScreenWidth - 58 - 12, _textField.frame.size.height);
    }
    
    _textField.returnKeyType = UIReturnKeySearch; // 修改键盘右下角 改为 搜索
    _textField.placeholder = [GDLocalizableClass getStringForKey:@"Search..."];
    [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_textField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [_textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_textField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [HttpRequest getWithUrl:search_recommend andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error)
     {
         if (!error) {
             NSError *Error = nil;
             _normalArray = [MTLJSONAdapter modelsOfClass:[SearchNormalModel class] fromJSONArray:response[@"result"] error:&Error];
         }
         [_tableView reloadData];
     }];
}

#pragma mark - textField
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchArray = nil;
    _membersArray = nil;
    _companiesArray = nil;
    _eventsArray = nil;
    _postsArray = nil;
    
    if (0 == textField.text.length) {
        _isSearch = NO;
        
        [self.tableView reloadData];
    } else {
        _isSearch = YES;
        if (urlSessionDataTask)
        {
            [urlSessionDataTask cancel];
        }
        @weakify(self)
        urlSessionDataTask = [HttpRequest getWithUrl:searchByKeyWord andViewContoller:self andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"keyword" : textField.text}] andBlock:^(id response, NSError *error)
        {
            @strongify(self)
            if (!error) {
                NSError *Error = nil;
                _searchArray = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:response[@"result"][@"searchResultUnites"] error:&Error];
                
                for (int i = 0; i < _searchArray.count; i++)
                {
                    if ([_searchArray[i].resultUnitType isEqualToString:@"USER"]) {
                        _membersArray =  _searchArray[i].users;
                        _membersString = [NSString stringWithFormat:@"%ld", (long)_searchArray[i].count];
                    } else if ([_searchArray[i].resultUnitType isEqualToString:@"COMPANY"]) {
                        _companiesArray = _searchArray[i].companies;
                        _companiesString = [NSString stringWithFormat:@"%ld", (long)_searchArray[i].count];
                    } else if ([_searchArray[i].resultUnitType isEqualToString:@"EVENT"]) {
                        _eventsArray = _searchArray[i].events;
                        _eventsString = [NSString stringWithFormat:@"%ld", (long)_searchArray[i].count];
                    } else {
                        _postsArray = _searchArray[i].feeds;
                        _postsString = [NSString stringWithFormat:@"%ld", (long)_searchArray[i].count];
                    }
                }
                [self.tableView reloadData];
                [textField resignFirstResponder];
            }
        }];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    [_tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [self textFieldDidBeginEditing:textField];
}

- (void)textFieldTextDidChange:(UITextField *)textField
{
    if (0 == textField.text.length) {
        _isSearch = NO;

        _searchArray = nil;
        _membersArray = nil;
        _companiesArray = nil;
        _eventsArray = nil;
        _postsArray = nil;

        [self.tableView reloadData];
    } else {
        return;
    }
}

#pragma mark - Tableview

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
        
        /* self.title = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld Attendees"], (long)[count integerValue]]; */
        if (0 == section) {
            if (0 != _membersArray.count) {
                headerView.headerLabel.text = 1 == _membersArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ member for '%@'"], @"1", _textField.text]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ members for '%@'"], _membersString, _textField.text];
            } else {
                return nil;
            }
        } else if (1 == section) {
            if (0 != _companiesArray.count) {
                headerView.headerLabel.text = 1 == _companiesArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ company for '%@'"], @"1", _textField.text]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ companies for '%@'"], _companiesString, _textField.text];
            } else {
                return nil;
            }
        } else if (2 == section) {
            if (0 != _eventsArray.count) {
                headerView.headerLabel.text = 1 == _eventsArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ event with '%@'"], @"1", _textField.text]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ events with '%@'"], _eventsString, _textField.text];
            } else {
                return nil;
            }
        } else {
            if (0 != _postsArray.count) {
                headerView.headerLabel.text = 1 == _postsArray.count ? [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ post with '%@'"], @"1", _textField.text]: [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ posts with '%@'"], _postsString, _textField.text];
            } else {
                return nil;
            }
        }
        
        return headerView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_isSearch) {
        SearchFooterView *footerView = [[SearchFooterView alloc] init];
        footerView.footerLabel.text = [GDLocalizableClass getStringForKey:@"VIEW ALL"];
        
        if (0 == section) {
            if (0 != _membersArray.count) {
                [self footerMembersTagGestureRecognizer:footerView];
            } else {
                return nil;
            }
        } else if (1 == section) {
            if (0 != _companiesArray.count) {
                [self footerCompaniesTagGestureRecognizer:footerView];
            } else {
                return nil;
            }
        } else if (2 == section) {
            if (0 != _eventsArray.count) {
                [self footerEventsTagGestureRecognizer:footerView];
            } else {
                return nil;
            }
        } else {
            if (0 != _postsArray.count) {
                [self footerPostsTagGestureRecognizer:footerView];
            } else {
                return nil;
            }
        }
        
        return footerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        CGFloat height = 50;
        
        if (0 == section) {
            return _membersArray.count == 0 ? 0.1 : height;
        } else if (1 == section) {
            return _companiesArray.count == 0 ? 0.1 : height;
        } else if (2 == section) {
            return _eventsArray.count == 0 ? 0.1 : height;
        } else {
            return _postsArray.count == 0 ? 0.1 : height;
        }
    } else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isSearch) {
        CGFloat height = 44;
        
        if (0 == section) {
            return _membersArray.count == 0 ? 0.1 : height;
        } else if (1 == section) {
            return _companiesArray.count == 0 ? 0.1 : height;
        } else if (2 == section) {
            return _eventsArray.count == 0 ? 0.1 : height;
        } else {
            return _postsArray.count == 0 ? 0.1 : height;
        }
    } else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch) {
        CGFloat height = 94;
        
        if (0 == indexPath.section) {
            return _membersArray.count == 0 ? 0 : height;
        } else if (1 == indexPath.section) {
            return _companiesArray.count == 0 ? 0 : height;
        } else if (2 == indexPath.section) {
            return _eventsArray.count == 0 ? 0 : height;
        } else {
            return _postsArray.count == 0 ? 0 : height;
        }
    } else {
        return 94;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSearch ? ((0 == _membersArray.count && 0 == _companiesArray.count && 0 == _eventsArray.count && 0 == _postsArray.count) ? 0 : 4) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 2;
    if (_isSearch) {
        if (0 == section) {
            return _membersArray.count <= 3 && _membersArray.count != 0 ? _membersArray.count : number;
        } else if (1 == section) {
            return _companiesArray.count <= 3 && _companiesArray.count != 0 ? _companiesArray.count : number;
        } else if (2 == section) {
            return _eventsArray.count <= 3 && _eventsArray.count != 0 ? _eventsArray.count : number;
        } else {
            return _postsArray.count <= 3 && _postsArray.count != 0 ? _postsArray.count : number;
        }

    } else {
        return _normalArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch) {
        if (0 == indexPath.section) {
            SearchMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchMembersCell" forIndexPath:indexPath];
            cell.searchMembersModel = _membersArray[indexPath.row];
            return cell;
        } else if (1 == indexPath.section) {
            SearchCompaniesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCompaniesCell" forIndexPath:indexPath];
            cell.searchCompaniesModel = _companiesArray[indexPath.row];
            return cell;
        } else if (2 == indexPath.section) {
            SearchEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchEventsCell" forIndexPath:indexPath];
            cell.searchEventsModel = _eventsArray[indexPath.row];
            return cell;
        } else {
            SearchPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchPostCell" forIndexPath:indexPath];
            cell.searchPostModel = _postsArray[indexPath.row];
            return cell;
        }
    } else {
        SearchNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchNormalCell" forIndexPath:indexPath];
        
        cell.searchNormalModel = _normalArray[indexPath.row];
//        cell.normalImageView.image = /*0 == indexPath.row ? [UIImage imageNamed:@"Menmber"] :*/ [UIImage imageNamed:@"Events"];
        
//        cell.normalLabel.text = /*0 == indexPath.row ? @"Members you may want to know":*/ [NSString stringWithFormat:@"%@ Events happening this week", @5];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isSearch) {
        if (0 == indexPath.section) {
            // 成员详情界面
            [mixPanel track:@"Search_members_Detail" properties:logInDic];
            ((NakedPerSonalDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:self]).userModel = _membersArray[indexPath.row];
        } else if (1 == indexPath.section) {
            // 公司详情界面
            [mixPanel track:@"Search_companies_Detail" properties:logInDic];
            ((NHCompanyDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"CompanyDetails" andViewController:@"NHCompanyDetailsViewController" andParent:self]).Details_ID = _companiesArray[indexPath.row].id;
        } else if (2 == indexPath.section) {
            // 活动详情页面
            [mixPanel track:@"Search_events_Detail" properties:logInDic];
            ((NakedEventsDetailViewController *)[Utility pushViewControllerWithStoryboard:@"Events" andViewController:@"NakedEventsDetailViewController" andParent:self]).eventsId = _eventsArray[indexPath.row].eventsId;
        } else {
            // feed 详情界面
            [mixPanel track:@"Search_posts_Detail" properties:logInDic];
            ((NakedHubFeedDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"FeedList" andViewController:@"NakedHubFeedDetailsViewController" andParent:self]).feedModel = _postsArray[indexPath.row];
        }
    } else {
        /* 推荐活动 埋点
         Search_Recommendes_members_recommendesDetail
         Search_Recommendes_companies_recommendesDetail
         Search_Recommendes_events_recommendesDetail
         Search_Recommendes_posts_recommendesDetail
         */
        [mixPanel track:@"Search_Recommendes_events_recommendesDetail" properties:logInDic];
        ((RecommendEventsViewController *)[Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"RecommendEventsViewController" andParent:self]).recommendType = @"EVENT";
    }
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

#pragma mark - footerMembers VIEW ALL
- (void)footerMembersTagGestureRecognizer:(UIView *)footerView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [tapGestureRecognizer addTarget:self action:@selector(footerMembers:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [footerView setUserInteractionEnabled:YES];
    [footerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)footerMembers:(UIGestureRecognizer*)sender
{
    // 跳转 Members
    [mixPanel track:@"Search_members_viewAll" properties:logInDic];
    SearchViewAllViewController *searchViewAllController = ((SearchViewAllViewController *)[Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewAllViewController" andParent:self]);
    searchViewAllController.resultUnitType = @"USER";
    searchViewAllController.keyWord = _textField.text;
}

#pragma mark - footerCompanies VIEW ALL
- (void)footerCompaniesTagGestureRecognizer:(UIView *)footerView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [tapGestureRecognizer addTarget:self action:@selector(footerCompanies:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [footerView setUserInteractionEnabled:YES];
    [footerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)footerCompanies:(UIGestureRecognizer*)sender
{
    // 跳转 Companies
    [mixPanel track:@"Search_companies_viewAll" properties:logInDic];
    SearchViewAllViewController *searchViewAllController = ((SearchViewAllViewController *)[Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewAllViewController" andParent:self]);
    searchViewAllController.resultUnitType = @"COMPANY";
    searchViewAllController.keyWord = _textField.text;
}

#pragma mark - footerEvents VIEW ALL
- (void)footerEventsTagGestureRecognizer:(UIView *)footerView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [tapGestureRecognizer addTarget:self action:@selector(footerEvents:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [footerView setUserInteractionEnabled:YES];
    [footerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)footerEvents:(UIGestureRecognizer*)sender
{
    // 跳转 Events
    [mixPanel track:@"Search_events_viewAll" properties:logInDic];
    SearchViewAllViewController *searchViewAllController = ((SearchViewAllViewController *)[Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewAllViewController" andParent:self]);
    searchViewAllController.resultUnitType = @"EVENT";
    searchViewAllController.keyWord = _textField.text;
}

#pragma mark - footerPosts VIEW ALL
- (void)footerPostsTagGestureRecognizer:(UIView *)footerView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [tapGestureRecognizer addTarget:self action:@selector(footerPosts:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [footerView setUserInteractionEnabled:YES];
    [footerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)footerPosts:(UIGestureRecognizer*)sender
{
    // 跳转 Posts
    [mixPanel track:@"Search_posts_viewAll" properties:logInDic];
    SearchViewAllViewController *searchViewAllController = ((SearchViewAllViewController *)[Utility pushViewControllerWithStoryboard:@"Search" andViewController:@"SearchViewAllViewController" andParent:self]);
    searchViewAllController.resultUnitType = @"FEED";
    searchViewAllController.keyWord = _textField.text;
}

- (IBAction)back:(id)sender
{
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

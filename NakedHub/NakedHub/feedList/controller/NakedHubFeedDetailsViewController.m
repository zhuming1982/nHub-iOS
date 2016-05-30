//
//  NakedHubFeedDetailsViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedHubFeedDetailsViewController.h"
#import "NakedHubFeedCell.h"
#import "NakedCommentCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIViewController+KeyboardAnimation.h"
#import "MBAutoGrowingTextView.h"
#import "UITableView+Refreshing.h"
#import "Utility.h"
#import "NakedHubCommentsModel.h"
#import "HttpRequest.h"
#import "UIViewController+DismissKeyboard.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NHFeedLikeCell.h"
#import "NakedPerSonalTableHeadSecionView.h"
#import "NakedPerSonalDetailsViewController.h"


#define COUNT 10

@interface NakedHubFeedDetailsViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property (weak, nonatomic) IBOutlet UIView *toolsView;

@property (weak, nonatomic) IBOutlet UITextField *commemtTextF;

@property (strong, nonatomic)  NakedPerSonalTableHeadSecionView *commentTitleView;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsBottomConstraint;
@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intPutToolsViewHeight;


@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *CommentsList;

@end

@implementation NakedHubFeedDetailsViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.page = 1;
    self.title = [GDLocalizableClass getStringForKey:@"Post"];
    
    [self.postBtn setTitle:[GDLocalizableClass getStringForKey:@"POST"] forState:UIControlStateNormal];
    [self.commemtTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Type your comment..."]];
    

    [self setupForDismissKeyboard];
    self.detailsTableView.estimatedRowHeight = 400;
    self.detailsTableView.rowHeight = UITableViewAutomaticDimension;
    [Utility configSubView:_postBtn CornerWithRadius:5.0];

//         [_textView becomeFirstResponder];
  
    
    
    @weakify(self)
    [[RACSignal merge:@[_textView.rac_textSignal,RACObserve(_textView, text)]] subscribeNext:^(NSString *text) {
        @strongify(self)
        self.commemtTextF.text = self.textView.text.length>0?@" ":@"";
        self.postBtn.hidden = self.textView.text.length>0?NO:YES;
        self.intPutToolsViewHeight.constant = self.textViewHeightConstraint.constant+20;
        [self.postBtn setBackgroundColor:self.textView.text.length>0? RGBACOLOR(233, 144, 29, 1.0):RGBACOLOR(74, 74, 74, 1.0)];
        self.postBtn.enabled = self.textView.text.length>0;
    }];
    
    
//    if (!_feedModel) {
    [HttpRequest getWithUrl:feed(_feedModel?_feedModel.feedId:_feedModelId) andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
            if (!error) {
                if (![response[@"result"] isKindOfClass:[NSNull class]]) {
                    self.feedModel = [MTLJSONAdapter modelOfClass:[NakedHubFeedModel class] fromJSONDictionary:response[@"result"] error:nil];
                    [self.detailsTableView reloadData];
                }
//                [self loadDate:NO];
            }
        
//            [self.detailsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
//    }
    
//    [self.detailsTableView setRefreshing:^(bool isPull) {
//        @strongify(self)
//        if (isPull) {
//            self.page = 1;
//        }
//        else
//        {
//            self.page++;
//        }
//        [self loadDate:NO];
//    }];
    self.detailsTableView.estimatedRowHeight = 400;
    self.detailsTableView.rowHeight = UITableViewAutomaticDimension;
//    [self loadDate:NO];

}
- (void)loadDate:(BOOL)isComment
{
    [HttpRequest getWithUrl:feed_feedComments andViewContoller:nil andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"feedId":@(_feedModel.feedId)/*,@"page":@(self.page),@"count":@(COUNT)*/}] andBlock:^(id response, NSError *error) {
        NSArray *tempArr = [NSArray array];
        if (!error) {
            tempArr = [MTLJSONAdapter modelsOfClass:[NakedHubCommentsModel class] fromJSONArray:response[@"result"] error:nil];
            if (self.page==1) {
                self.CommentsList = [NSMutableArray arrayWithArray:tempArr];
            }
            else
            {
                [self.CommentsList addObjectsFromArray:tempArr];
            }
        }
        [self.detailsTableView endTableViewRefreshing:self.page==1 andisHiddenFooter:tempArr.count<COUNT];
        if (isComment&&self.CommentsList.count>0) {
            [self.detailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.CommentsList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}
- (IBAction)post:(UIButton *)sender {

    [mixPanel track:@"Feed_comment" properties:logInDic];
    if ([Utility isEmpty:_textView.text]) {
        self.textView.text = nil;
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"You can't send meesage without any characters."]];
        return;
    }
    @weakify(self)
    [HttpRequest postWithURLSession:feed_comment andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"feedId":@(_feedModel.feedId),@"content":_textView.text}] andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            self.commemtTextF.text = @"";
            self.textView.text = @"";
            self.textViewHeightConstraint.constant = 34;
            self.intPutToolsViewHeight.constant = self.textViewHeightConstraint.constant+20;
            [_textView resignFirstResponder];
            _feedModel.commentNum = [response[@"result"][@"ext"][@"commentNum"] integerValue];
            _feedModel.commented = YES;
            NakedHubCommentsModel *commentsModel = [MTLJSONAdapter modelOfClass:[NakedHubCommentsModel class] fromJSONDictionary:response[@"result"] error:nil];
            [_feedModel.comments addObject:commentsModel];
            [self.detailsTableView reloadData];
            [self.detailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_feedModel.comments.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            if (self.commentsCallBack) {
                self.commentsCallBack(_feedModel);
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.toolsBottomConstraint.constant = CGRectGetHeight(keyboardRect);
        } else {
            self.toolsBottomConstraint.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return self.feedModel.comments.count;
        }
            break;
        case 2:
        {
            return self.feedModel.likers.count;;
        }
            break;
        default:
            break;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2&&_feedModel.likers.count>0) {
        if (!_commentTitleView) {
            _commentTitleView = [[NakedPerSonalTableHeadSecionView alloc]init];
        }
        _commentTitleView.titleLabel.text = [GDLocalizableClass getStringForKey:@"Likes"];
        return _commentTitleView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 2&&_feedModel.likers.count>0)?40:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
        NakedHubFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubFeedCell" forIndexPath:indexPath];
        cell.feedModel = _feedModel;
        @weakify(cell)
        [cell setClikeImageViewActionBlock:^(UIImageView *imageV) {
            @strongify(cell)
            [cell showHostImageView:cell.feedImageView andVC:self];
        }];
        [cell setClikeUserAvatarImageViewActionBlock:^(UIImageView *imgV) {
            @strongify(cell)
            [cell gotoUserDetailsVC:_feedModel.user andVC:self];
        }];
        [cell setActionClikeLinkBlock:^(NSURL *url) {
            @strongify(cell)
            [cell ClikeWithLink:url andController:self];
        }];
        [cell setRecognizeQRCodeCallBack:^{
            @strongify(cell)
            //        [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:cell.QRCodeResul]];
            [cell ClikeWithLink:[NSURL URLWithString:cell.QRCodeResul] andController:self];
        }];
        [cell setButtonActionBlock:^(UIButton *sender) {
            @strongify(cell)
            switch (sender.tag) {
                case 99:
                {
                    //like
                    @weakify(self)
                    [cell likeClikeWithFeedModel:cell.feedModel andController:self and:^(NakedHubFeedModel *model) {
                        @strongify(self)
                        self.feedModel = model;
                        [self.detailsTableView reloadData];
                        if (self.likeCallBack) {
                            self.likeCallBack(model);
                        }
                    }];
                }
                    break;
                case 100:
                {
                    //comments
                    [self.textView becomeFirstResponder];
                }
                    break;
                default:
                {
                    //more
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    [alertC addAction:[UIAlertAction
                                actionWithTitle:[GDLocalizableClass getStringForKey:@"Report"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                    
                        [mixPanel track:@"Feed_report" properties:logInDic];
                                    
                        [cell ForWardClikeWithFeedModel:cell.feedModel andController:self];
                    }]];
                    [alertC addAction:[UIAlertAction
                                    actionWithTitle:[GDLocalizableClass getStringForKey:@"Cancel"]  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alertC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
                    break;
            }
        }];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        NakedCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedCommentCell" forIndexPath:indexPath];
        cell.commentsModel = _feedModel.comments[indexPath.row];
        @weakify(cell)
        [cell setLikeClikeCallBack:^{
            @strongify(cell)            
            [cell likeClikeWithFeedModel:cell.commentsModel andController:nil and:^(NakedHubCommentsModel *model) {
            }];
        }];
        [cell setActionClikeLinkBlock:^(NSURL *url) {
            @strongify(cell)
            [cell ClikeWithLink:url andController:self];
        }];
        [cell setClikeUserAvatarImageViewActionBlock:^(UIImageView *imgV) {
            @strongify(cell)
            [cell gotoUserDetailsVC:cell.commentsModel.user andVC:self];
        }];
        return cell;
    }
    else
    {
        NHFeedLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NHFeedLikeCell" forIndexPath:indexPath];
        cell.user = _feedModel.likers[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [mixPanel track:@"Feed_userDetail" properties:logInDic];
        ((NakedPerSonalDetailsViewController*)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedPerSonalDetailsViewController" andParent:self]).userModel = _feedModel.likers[indexPath.row];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES
     ];
}
@end

//
//  NakedEventsDetailViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailViewController.h"

#import "NakedEventsAttendeesViewController.h"

#import "NakedEventsDetailInfoCell.h"
#import "NakedEventsDetailMapCell.h"
#import "NakedEventsDetailAboutCell.h"

#import "NakedEventsDetailModel.h"

#import "UITableView+Refreshing.h"
#import "HttpRequest.h"
#import "JXMapNavigationView.h"
#import "LocationManager.h"

@interface NakedEventsDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *attendButton;

@property (nonatomic, strong) NakedEventsDetailModel *eventsDetailModel;

@end

@implementation NakedEventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = [GDLocalizableClass getStringForKey:@"Event Detail"];

    [HttpRequest getWithUrl:events(_eventsId) andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error)
    {
        if (!error) {
//            NSString *serverTime = [NSString stringWithFormat:@"%@", response[@"serverTime"]];

            NSError *Error = nil;
            _eventsDetailModel = [MTLJSONAdapter modelOfClass:[NakedEventsDetailModel class] fromJSONDictionary:response[@"result"] error:&Error];
            /* 过滤字符串中的换行 */
            self.title = [_eventsDetailModel.title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_eventsDetailModel.background] placeholderImage:[UIImage imageNamed:@"feedImage"]];
            
            if (/*_eventsDetailModel.startTime > [serverTime integerValue]*/ _eventsDetailModel.canAttend) {
                if (_eventsDetailModel.attended) {
                    //            _attendButton.backgroundColor = RGBACOLOR(208.0, 208.0, 212.0, 1.0);
                    [_attendButton setTitle:[GDLocalizableClass getStringForKey:@"I AM GOING"] forState:UIControlStateNormal];
                } else {
                    //            _attendButton.backgroundColor = RGBACOLOR(233.0, 144.0, 29.0, 1.0);
                    [_attendButton setTitle:[GDLocalizableClass getStringForKey:@"ATTEND EVENT"] forState:UIControlStateNormal];
                }
            } else {
                _attendButton.userInteractionEnabled = NO;
                _attendButton.backgroundColor = RGBACOLOR(208.0, 208.0, 212.0, 1.0);
                [_attendButton setTitle:[GDLocalizableClass getStringForKey:@"EVENT IS EXPIRED"] forState:UIControlStateNormal];
            }
            
            [self.tableView reloadData];
        }
    }];
    self.tableView.estimatedRowHeight = 246;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (1 == indexPath.row)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (1 == indexPath.row)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 2:
        {
            if (1 == indexPath.row)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell" forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        default:
            break;
    }
    
    if (0 == indexPath.section) {
        NakedEventsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsDetailInfoCell" forIndexPath:indexPath];
        
        cell.eventsDetailModel = _eventsDetailModel;
        cell.attendeesList = _eventsDetailModel.participators;
        return cell;
    } else if (1 == indexPath.section) {
        NakedEventsDetailMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsDetailMapCell" forIndexPath:indexPath];
        
        cell.eventsDetailModel = _eventsDetailModel;
        UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInsideAddress)];
        [cell.addressLabel addGestureRecognizer:addressTap];
        
        UITapGestureRecognizer *telephoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInsideTelephone)];
        [cell.telephoneLabel addGestureRecognizer:telephoneTap];
        
        return cell;
    } else {
        NakedEventsDetailAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsDetailAboutCell" forIndexPath:indexPath];
        
        cell.eventsDetailModel = _eventsDetailModel;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)touchUpInsideTelephone
{
    [mixPanel track:@"Event_Detail_Phone" properties:logInDic]; // 打电话
    if (0 == _eventsDetailModel.hub.phone.length) {
        return;
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _eventsDetailModel.hub.phone]]];
    }
}

- (void)touchUpInsideAddress
{
    [mixPanel track:@"Event_Detail_Address" properties:logInDic]; // 调用系统地图
    JXMapNavigationView *viewController = [[JXMapNavigationView alloc] init];
    [viewController showMapNavigationViewFormcurrentLatitude:[LocationManager shared].userLocation.coordinate.latitude currentLongitute:[LocationManager shared].userLocation.coordinate.longitude TotargetLatitude:_eventsDetailModel.hub.location.latitude targetLongitute:_eventsDetailModel.hub.location.longitude toName:_eventsDetailModel.hub.address];
    [self.view addSubview:viewController];
}


- (IBAction)back:(id)sender
{
    if (!_eventsDetailModel.attended) {
        if (_isRefresh) {
            if (_popBack) {
                _popBack(_eventsId);
            }
            if (_popRecommendBack) {
                _popRecommendBack();
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 分享
- (IBAction)share:(id)sender
{
    [mixPanel track:@"Event_Detail_Share" properties:logInDic]; 
    NSURL *url = [NSURL URLWithString:_eventsDetailModel.shareUrl];
    
    if (url == nil) {
        return;
    }
    NSArray *objectsToShare = @[url, _eventsDetailModel.title, _headerImageView.image];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
//    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
//                                    UIActivityTypePostToWeibo,
//                                    UIActivityTypeMessage, UIActivityTypeMail,
//                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
//                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
//                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
//                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
//    activityViewController.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    // 回调
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"分享 %@", activityType);
        if (activityType == nil) {
//            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Cancel"]];
        } else {
            if (completed)
            {
//                [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Share Success!"]];
                NSLog(@"The Activity: %@ was completed", activityType);
            } else {
//                [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Share Failure!"]];
                NSLog(@"The Activity: %@ was NOT completed", activityType);
            }
        }
    };
}

// 报名参加活动
- (IBAction)attendButtonClick:(id)sender
{
    [mixPanel track:@"Event_Detail_attendEvent" properties:logInDic]; // 报名参加活动
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[GDLocalizableClass getStringForKey:_eventsDetailModel.attended ? @"I AM GOING?": @"ATTEND EVENT?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *attendAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"CONFIRM"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self attendHttpRequest];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"CANCEL"] style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:attendAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)attendHttpRequest
{
    [HttpRequest postWithURLSession:events_attend andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"eventId": @(_eventsDetailModel.eventsId)}] andBlock:^(id response, NSError *error)
     {
         if (!error) {
             NSError *Error = nil;
             _eventsDetailModel = [MTLJSONAdapter modelOfClass:[NakedEventsDetailModel class] fromJSONDictionary:response[@"result"] error:&Error];
             
             if (_eventsDetailModel.attended) {
                 //                 _attendButton.backgroundColor = RGBACOLOR(208.0, 208.0, 212.0, 1.0);
                 [_attendButton setTitle:[GDLocalizableClass getStringForKey:@"I AM GOING"] forState:UIControlStateNormal];
                 [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Application Successful!"]];
             } else {
                 //                 _attendButton.backgroundColor = RGBACOLOR(233.0, 144.0, 29.0, 1.0);
                 [_attendButton setTitle:[GDLocalizableClass getStringForKey:@"ATTEND EVENT"] forState:UIControlStateNormal];
                 [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Cancelation Successful!"]];
             }
             [self.tableView reloadData];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToday" object:nil];
     }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [mixPanel track:@"Event_Detail_attendList" properties:logInDic]; // 跳转到参与者列表
    NakedEventsAttendeesViewController *attendeesViewController = [segue destinationViewController];
    attendeesViewController.eventsId = _eventsDetailModel.eventsId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

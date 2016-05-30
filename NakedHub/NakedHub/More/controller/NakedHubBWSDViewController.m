//
//  NakedHubBWSDViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBWSDViewController.h"
#import "NakedBookWorkSpaceMapCell.h"
#import "JXMapNavigationView.h"
#import "LocationManager.h"
#import "NHReservationOrdersListModel.h"

@interface NakedHubBWSDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;

@end

@implementation NakedHubBWSDViewController
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.title = _hubModel.name;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_hubModel.picture] placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    [self.bookBtn setBackgroundColor:_hubModel.remainingTimes?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:212.0/255.0 alpha:1.0]];
    self.bookBtn.enabled = _hubModel.remainingTimes;
    
    [self.bookBtn setTitle:[GDLocalizableClass getStringForKey:@"CONFIRM RESERVATION"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NakedBookWorkSpaceMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookWorkSpaceMapCell" forIndexPath:indexPath];
    cell.hubModel = _hubModel;
    cell.dateLabel.text = [Utility get_book_YYYYMMDD:_selectDate?_selectDate:[NSDate date]];
//    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
//    cell.dateLabel.text =  [NSString stringWithFormat:@"%@ %@ %@",dateArr[2],[Utility ZYY:[dateArr[1]integerValue]],dateArr[0]];

    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAddress)];
    [cell.addressLabel addGestureRecognizer:addressTap];
    
    UITapGestureRecognizer *tepTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchtep)];
    [cell.phoneNumberLabel addGestureRecognizer:tepTap];
    
    cell.messageLabel.text = _cancelRule;
    return cell;
}

- (void) touchtep
{
    [mixPanel track:@"bookWorkSpace_Detail_Phone" properties:logInDic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_hubModel.phone]]];
}
- (void) touchAddress
{
    [mixPanel track:@"bookWorkSpace_Detail_Address" properties:logInDic];
    JXMapNavigationView *vc = [[JXMapNavigationView alloc] init];
    [vc showMapNavigationViewFormcurrentLatitude:[LocationManager shared].userLocation.coordinate.latitude currentLongitute:[LocationManager shared].userLocation.coordinate.longitude TotargetLatitude:_hubModel.location.latitude targetLongitute:_hubModel.location.longitude toName:_hubModel.address];
    [self.view addSubview:vc];
}


- (IBAction)confirmHubAction:(UIButton *)sender {
    [mixPanel track:@"bookWorkSpace_Detail_Reservation" properties:logInDic];
    @weakify(self)
    [HttpRequest postWithURLSession:reservation_book_workspace andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"hubId":@(_hubModel.hubId),@"date":[Utility getYYYYMMDD:_selectDate?_selectDate:[NSDate date]],@"reservationType":@"HOTDESK"}] andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            NHReservationOrdersListModel *order = [MTLJSONAdapter modelOfClass:[NHReservationOrdersListModel class] fromJSONDictionary:response[@"result"] error:nil];
            self.hubModel.remainingTimes = order.hub.remainingTimes;
            if (self.ConferenceHubSucessCallBack) {
                self.ConferenceHubSucessCallBack();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
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

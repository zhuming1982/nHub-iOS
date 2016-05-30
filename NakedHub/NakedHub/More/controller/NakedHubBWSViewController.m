//
//  NakedHubBWSViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBWSViewController.h"
#import "NakedBookAddressCell.h"
#import "NakedBookDateCell.h"
#import "NakedHubBookWorkspaceCell.h"
#import "UITableView+Refreshing.h"
#import "NakedHubSelectViewController.h"
#import "RMDateSelectionViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "NakedHubModel.h"
#import "NakedHubBWSDViewController.h"
#import "NHReservationOrdersListModel.h"

#import "NSDate+Category.h"


#define COUNT 10

@interface NakedHubBWSViewController ()
@property (nonatomic,strong) NSDate *selectDate;

@property (nonatomic,strong) NakedHubModel *hubModel;
@property (nonatomic,copy) NSString *cancelRule;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray<NakedHubModel*> *workSpaceList;
@property (weak, nonatomic) IBOutlet UILabel *queTaLabel;

@end

@implementation NakedHubBWSViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMyQuota
{
    @weakify(self)
    [HttpRequest getWithUrl:user_myQuota andViewContoller:self andHudMsg:nil andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            if (response[@"result"]) {
                if (response[@"result"][@"balance"]) {
                    self.queTaLabel.text = @([response[@"result"][@"balance"] integerValue]).stringValue;
                    if ([self.queTaLabel.text integerValue] == 0) {
                        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"You have already used all of your workspace credits for this month. Please check with your Community Manager to arrange more."]];
                    }
                }
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"Book Workspace"];
    
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
            [self getMyQuota];
        }
        else
        {
            self.page++;
        }
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]) {
            [attr setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"] forKey:@"hubId"];
        }
        
        if (_selectDate) {
            [attr setObject:[Utility getYYYYMMDD:_selectDate] forKey:@"date"];
        }
        
        [HttpRequest getWithUrl:reservation_hubs andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
            NSArray *tempArr = [NSArray array];
            if (!error) {
                NSError *error1 =nil;
                _cancelRule = response[@"result"][@"cancelRule"];
               tempArr = [MTLJSONAdapter modelsOfClass:[NakedHubModel class] fromJSONArray:response[@"result"][@"hubs"] error:&error1];
                NSLog(@"error = %@",error1);
                if (isPull) {
                    self.workSpaceList = [NSMutableArray arrayWithArray:tempArr];
                }
                else
                {
                    [self.workSpaceList addObjectsFromArray:tempArr];
                }
            }
            
            [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:tempArr.count<COUNT];
        }];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!_hubModel)
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]) {
            _hubModel = [[NakedHubModel alloc]init];
            _hubModel.hubId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"] integerValue];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubaddress"]) {
            _hubModel.address = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubaddress"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubname"]) {
            _hubModel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubname"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubpicture"]) {
            _hubModel.picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"hubpicture"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        default:
            return self.workSpaceList.count;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NakedBookAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookAddressCell" forIndexPath:indexPath];
//        cell.hubModel = _hubModel;
        cell.hubNameLabel.text = [GDLocalizableClass getStringForKey:@"Shanghai"] ;
//        [cell.hubNameLabel setFrame:CGRectMake(cell.hubNameLabel.frame.origin.x, cell.hubNameLabel.frame.origin.y+7, cell.hubNameLabel.frame.size.width, cell.hubNameLabel.frame.size.height)];
//        cell.addressLabel.hidden = YES;
        return cell;
    }
    if (indexPath.section==1) {
        NakedBookDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookDateCell" forIndexPath:indexPath];
        
//        NSString *day=[Utility getDay:[NSDate date]];
//        NSString *year= [Utility getYear:[NSDate date]];
//        NSString *month = [Utility getMonth:[NSDate date]];
//        NSString *need_date=[NSString stringWithFormat:@"%@ %@ %@",day,month,year];
        
        cell.date = _selectDate?_selectDate:[NSDate date];
        return cell;
    }
    NakedHubBookWorkspaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubBookWorkspaceCell" forIndexPath:indexPath];
    cell.hubModel = _workSpaceList[indexPath.row];
    
    @weakify(cell)
    @weakify(self)
    [cell setBookNowCallBack:^{
        @strongify(cell)
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[GDLocalizableClass getStringForKey:@"RESERVATION?"] message:nil /*[NSString stringWithFormat:@"是否立即预定%@的工位", cell.hubModel.name]*/ preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"CANCEL"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *nowAction = [UIAlertAction actionWithTitle:[GDLocalizableClass getStringForKey:@"CONFIRM"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            @strongify(cell)
            [HttpRequest postWithURLSession:reservation_book_workspace andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"hubId":@(cell.hubModel.hubId),@"date":[Utility getYYYYMMDD:_selectDate?_selectDate:[NSDate date]],@"reservationType":@"HOTDESK"}] andBlock:^(id response, NSError *error) {
//                @strongify(cell)
//                @strongify(self)
                if (!error) {
                    NHReservationOrdersListModel *order = [MTLJSONAdapter modelOfClass:[NHReservationOrdersListModel class] fromJSONDictionary:response[@"result"] error:nil];
                    cell.hubModel.remainingTimes = order.hub.remainingTimes;
                    cell.availableLabel.text = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%li AVAILABLE"],(long)cell.hubModel.remainingTimes];
                    [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Your reservation is confirmed!"]];
                    [self getMyQuota];
                }
                else{
                    [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
                }
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:nowAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        [self showSelectDatePickerView];
    }
}


- (void)showSelectDatePickerView
{
    [mixPanel track:@"bookWorkSpace_Date" properties:logInDic];
    @weakify(self)
    RMAction *selectAction = [RMAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Select"]  style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        @strongify(self)
        self.selectDate = ((UIDatePicker *)controller.contentView).date;
        NakedBookDateCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.date = ((UIDatePicker *)controller.contentView).date;
        [self.tableView.header beginRefreshing];
    }];
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Cancel"]  style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minimumDate = [NSDate date];
//    dateSelectionController.title = [GDLocalizableClass getStringForKey:@"Please select a date"] ;
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [mixPanel track:@"bookWorkSpace_listClick" properties:logInDic];
    NakedHubBWSDViewController *bwsdVC = [segue destinationViewController];
    bwsdVC.title = _workSpaceList[self.tableView.indexPathForSelectedRow.row].name;
    bwsdVC.hubModel = _workSpaceList[self.tableView.indexPathForSelectedRow.row];
    bwsdVC.selectDate = _selectDate;
    bwsdVC.cancelRule = _cancelRule;
    @weakify(self)
    [bwsdVC setConferenceHubSucessCallBack:^{
        @strongify(self)
        [self getMyQuota];
        [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Your reservation is confirmed!"]];
        [self.tableView reloadData];
    }];
}


@end

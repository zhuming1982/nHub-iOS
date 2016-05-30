//
//  NakedBookRoomViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookRoomViewController.h"
#import "NakedBookAddressCell.h"
#import "NakedBookDateCell.h"
#import "NakedBookRoomCell.h"
#import "UITableView+Refreshing.h"
#import "NakedBookRoomModel.h"
#import "NSDate+MTDates.h"
#import "NSDateComponents+MTDates.h"
#import "NakedHubSelectViewController.h"
#import "RMDateSelectionViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "NakedConferenceRoomViewController.h"

#define COUNT 10

@interface NakedBookRoomViewController ()<UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *ScrollViews;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString * cancelRule;
@property (nonatomic,assign) CGPoint offSet;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray<NakedBookRoomModel*> *roomList;
//@property (nonatomic,copy) NSString *selectDate;

@property (nonatomic,strong) NSDate *selectDate;

@property (nonatomic,strong) NakedHubModel *hubModel;

@end

@implementation NakedBookRoomViewController
- (IBAction)back:(id)sender {
                            if (_PopBack) {
                                _PopBack();
                            }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"Book Room"];
    
    _ScrollViews = [NSMutableArray array];
    @weakify(self)
    [self.tableView setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else
        {
            self.page++;
        }
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
        
        if(!_hubModel)
        {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"]) {
                [attr setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"hubID"] forKey:@"hubId"];
            }
        }
        else
        {
            [attr setObject:@(_hubModel.hubId) forKey:@"hubId"];
        }
        
        if (_selectDate) {
            [attr setObject:[Utility getYYYYMMDD:_selectDate] forKey:@"date"];
        }
        
        [HttpRequest getWithUrl:reservation_index andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
            NSArray *tempArr = [NSArray array];
            if (!error) {
                NSError *error1 =nil;
                _cancelRule = response[@"result"][@"cancelRule"];
                tempArr = [MTLJSONAdapter modelsOfClass:[NakedBookRoomModel class] fromJSONArray:response[@"result"][@"meetingRooms"] error:&error1];
                NSLog(@"error = %@",error1);
                if (isPull) {
                    self.roomList = [NSMutableArray arrayWithArray:tempArr];
                }
                else
                {
                    [self.roomList addObjectsFromArray:tempArr];
                }
            }
            [self.tableView endTableViewRefreshing:isPull andisHiddenFooter:tempArr.count<COUNT];
        }];
    }];
    [self.tableView.header beginRefreshing];
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
    
//    NakedBookAddressCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if (_hubModel) {
//        cell.hubNameLabel.text = _hubModel.name;
//        cell.addressLabel.text = _hubModel.address;
//    }
//    else
//    {
//        cell.hubNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
//        cell.addressLabel.text = [GDLocalizableClass getStringForKey:@"please select hub"];
//    }
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
            return self.roomList.count;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NakedBookAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookAddressCell" forIndexPath:indexPath];
        cell.hubModel = _hubModel;
        return cell;
    }
    if (indexPath.section==1) {
        NakedBookDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookDateCell" forIndexPath:indexPath];
        cell.date = _selectDate?_selectDate:[NSDate date];
        return cell;
    }
    NakedBookRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookRoomCell" forIndexPath:indexPath];
    cell.roomModel = self.roomList[indexPath.row];
    [cell setScorllViewCallBack:^(CGPoint offSet) {
        _offSet = offSet;
        for (UITableViewCell * cell in self.tableView.visibleCells) {
            if ([cell isKindOfClass:[NakedBookRoomCell class]]) {
                [((NakedBookRoomCell*)cell).timeCollectionView setContentOffset:offSet];
            }
        }
    }];
    [cell.timeCollectionView setContentOffset:_offSet];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section>1?260.0:68.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [mixPanel track:@"bookRoom_selectLocation" properties:logInDic];
        NakedHubSelectViewController *SelectViewController = (NakedHubSelectViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedHubSelectViewController" andParent:self];
        SelectViewController.isBook = YES;
        SelectViewController.selectModel = _hubModel;
        @weakify(self)
        [SelectViewController setSelectHubCallBack:^(NakedHubModel *hubModel) {
            @strongify(self)
            NakedBookAddressCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.hubModel = hubModel;
            self.hubModel = hubModel;
            [self.tableView.header beginRefreshing];
        }];
    }
    else if (indexPath.section == 1)
    {
        [self showSelectDatePickerView];
    }
}


- (void)showSelectDatePickerView
{
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
    [mixPanel track:@"bookRoom_Date" properties:logInDic];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    [mixPanel track:@"bookRoom_listClick" properties:logInDic];
    ((NakedConferenceRoomViewController*)[segue destinationViewController]).bookRoomModel = _roomList[self.tableView.indexPathForSelectedRow.row];
    ((NakedConferenceRoomViewController*)[segue destinationViewController]).selectDate = _selectDate;
    ((NakedConferenceRoomViewController*)[segue destinationViewController]).cancelRule = _cancelRule;
    ((NakedConferenceRoomViewController*)[segue destinationViewController]).title = _roomList[self.tableView.indexPathForSelectedRow.row].name;
    [((NakedConferenceRoomViewController*)[segue destinationViewController])setConferenceRoomSucessCallBack:^{
        [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Your reservation is confirmed!"]];
        [self.tableView reloadData];
    }];
}


@end

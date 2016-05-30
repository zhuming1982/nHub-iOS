//
//  NakedConferenceRoomViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedConferenceRoomViewController.h"
#import "NakedBookDateCell.h"
#import "NakedBookRoomSelectTimeCell.h"
#import "NakedHubBookRoomPriceCell.h"
#import "NakedHubBookRoomAmenitiesCell.h"
#import "NakedHubBookRoomMeetingCell.h"
#import "TPKeyboardAvoidingTableView.h"



@interface NakedConferenceRoomViewController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UIButton *membersBtn;
@property (weak, nonatomic) IBOutlet UIButton *floorBtn;
@property (nonatomic,strong) NSMutableDictionary *attr;

@property (weak, nonatomic) IBOutlet UIButton *conferenceBtn;

@end

@implementation NakedConferenceRoomViewController
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmReservation:(UIButton *)sender {
    [mixPanel track:@"Book_room_confirmReservation" properties:logInDic];
    @weakify(self)
    [HttpRequest postWithURLSession:reservation_book_mettingRoom andViewContoller:self andHudMsg:@"" andAttributes:self.attr andBlock:^(id response, NSError *error) {
       @strongify(self)
        if (!error) {
            NakedBookRoomModel *model = [MTLJSONAdapter modelOfClass:[NakedBookRoomModel class] fromJSONDictionary:response[@"result"] error:nil];
            self.bookRoomModel.reservationTimeUnites = model.reservationTimeUnites;
            if (self.ConferenceRoomSucessCallBack) {
                self.ConferenceRoomSucessCallBack();
                [self back:nil];
            }
        }
        else
        {
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.multipleTouchEnabled = NO;
    self.tableView.exclusiveTouch = YES;
    
//    self.title = [GDLocalizableClass getStringForKey:@"Meeting Room 6"];
    [self.conferenceBtn setTitle:[GDLocalizableClass getStringForKey:@"CONFIRM RESERVATION"] forState:UIControlStateNormal];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_roomImageView sd_setImageWithURL:[NSURL URLWithString:_bookRoomModel.picture] placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    [_membersBtn setTitle:[NSString stringWithFormat:@" %li",(long)_bookRoomModel.seats] forState:UIControlStateNormal];
    [_floorBtn setTitle:[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@" %li/F"],(long)_bookRoomModel.floor] forState:UIControlStateNormal];
    _attr = [NSMutableDictionary dictionaryWithDictionary:@{@"hubId":@(_bookRoomModel.hub.hubId),@"meetingRoomId":@(_bookRoomModel.roomId),@"reservationType":@"MEETINGROOM"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void) setTimeLineWithRect:(CGRect)rt
{
    NakedBookDateCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger indexStart = rt.origin.x/40;
    NSInteger indexEnd = (rt.origin.x+rt.size.width)/40;
    [_attr setObject:[NSString stringWithFormat:@"%@ %@",[Utility getYYYYMMDD:_selectDate?_selectDate:[NSDate date]],self.bookRoomModel.reservationTimeUnites[indexStart].date] forKey:@"startDate"];
    [_attr setObject:[NSString stringWithFormat:@"%@ %@",[Utility getYYYYMMDD:_selectDate?_selectDate:[NSDate date]],self.bookRoomModel.reservationTimeUnites[indexEnd].date] forKey:@"endDate"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",self.bookRoomModel.reservationTimeUnites[indexStart].date,self.bookRoomModel.reservationTimeUnites[indexEnd].date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            NakedBookDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookDateCell" forIndexPath:indexPath];
            cell.date = _selectDate?_selectDate:[NSDate date];
            NakedBookRoomSelectTimeCell *SelectTimeCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            if (SelectTimeCell.selectTV) {
                
                
               CGRect rect = [SelectTimeCell.CollectionView convertRect:SelectTimeCell.selectTV.frame fromView:SelectTimeCell];
                
                NSInteger indexStart = rect.origin.x/40;
                NSInteger indexEnd = (rect.origin.x+rect.size.width)/40;
                
                
                NSLog(@"indexStart = %li",(long)indexStart);
                NSLog(@"indexStart = %li",(long)indexEnd);
                
                if ((indexStart>self.bookRoomModel.reservationTimeUnites.count||indexEnd>self.bookRoomModel.reservationTimeUnites.count)&&(indexStart<0||indexEnd<0)) {}
                else
                {
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",self.bookRoomModel.reservationTimeUnites[indexStart].date,self.bookRoomModel.reservationTimeUnites[indexEnd].date];
                }
            }
            
            return cell;
        }
            break;
        case 1:
        {
            NakedBookRoomSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedBookRoomSelectTimeCell" forIndexPath:indexPath];
            @weakify(cell)
            @weakify(self)
            [cell setBeginCallBack:^{
                tableView.scrollEnabled = NO;
            }];
            [cell setEndCallBack:^{
                tableView.scrollEnabled = YES;
            }];
            [cell  setScalingBeginCallBack:^{
                tableView.scrollEnabled = NO;
            }];
            [cell  setScalingEndCallBack:^{
                tableView.scrollEnabled = YES;
            }];
            [cell setChangeTVFrame:^(BOOL isAllowBook) {
                @strongify(cell)
                @strongify(self)
                [self setTimeLineWithRect:[cell.CollectionView convertRect:cell.selectTV.frame fromView:cell]];
                [self.conferenceBtn setBackgroundColor:isAllowBook?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:212.0/255.0 alpha:1.0]];
                self.conferenceBtn.enabled = isAllowBook;
            }];
            cell.bookRoomModel = _bookRoomModel;
            return cell;
        }
            break;
//        case 2:
//        {
//            NakedHubBookRoomPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubBookRoomPriceCell" forIndexPath:indexPath];
//            cell.costContentLabel.text = [NSString stringWithFormat:@"%li credits",(long)_bookRoomModel.price];
//            return cell;
//        }
//            break;
        case 2:
        {
            NakedHubBookRoomAmenitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubBookRoomAmenitiesCell" forIndexPath:indexPath];
            cell.contentLabel.text = _bookRoomModel.introduction;
            return cell;
        }
            break;
        case 3:
        {
            NakedHubBookRoomMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubBookRoomMeetingCell" forIndexPath:indexPath];
            @weakify(self)
            [[RACSignal merge:@[RACObserve(cell.contentTextView, text),cell.contentTextView.rac_textSignal]] subscribeNext:^(NSString *text) {
                @strongify(self)
                [self.attr setObject:text forKey:@"introduction"];
            }];
            cell.contentTextView.text = self.attr[@"introduction"];
            cell.descriptionLabel.text = self.cancelRule;
            return cell;
        }
            break;
        default:
            break;
    }
    NakedHubBookRoomMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubBookRoomMeetingCell" forIndexPath:indexPath];
    return cell;
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

//
//  NHReservationsListViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/4/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHReservationsDetailViewController.h"
#import "NHReservationDetailTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyMapAnnotation.h"
#import "NHReservationOrdersListModel.h"

#import "HttpRequest.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "UITableView+Refreshing.h"
#import "JXMapNavigationView.h"
#import "LocationManager.h"

#define COUNT 10


@interface NHReservationsDetailViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
}
@property (nonatomic,strong) NHReservationDetailTableViewCell *map_cell;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *arrayData;


@end

@implementation NHReservationsDetailViewController
@synthesize Detail_tableview,map_cell,Model,haha,arrayData;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.Detail_tableview.delegate=self;
    self.Detail_tableview.dataSource=self;
    self.title= [GDLocalizableClass getStringForKey:@"Reservations Detail"];
    [self.Cancel_out setTitle:[GDLocalizableClass getStringForKey:@"CANCEL ORDER"] forState:UIControlStateNormal];
    
    [self update];

}

-(void)update{
    
        [HttpRequest getWithUrl:reservation_detail(_Reservation_id) andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
            if (!error) {
                Model= [MTLJSONAdapter modelOfClass:[NHReservationOrdersListModel class] fromJSONDictionary:response[@"result"] error:nil];


            }
            [self.Detail_tableview reloadData];
        }];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//return heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 662;
}
//return numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *v1tableviewcell = @"NHReservationDetailTableViewCell";
    map_cell = [Detail_tableview dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
    map_cell.ReservationOrdersListModel=Model;
        
    if(Model!=nil){
        map_cell.My_Map.hidden=NO;
        map_cell.address_lab.hidden=NO;
        map_cell.phone_lab.hidden=NO;
        self.Cancel_out.hidden=NO;
  
        return map_cell;
    }else{
        map_cell.title_label.text=nil;
        map_cell.time_label.text=nil;
        map_cell.date_lab.text=nil;
        map_cell.address_lab.hidden=YES;
        map_cell.phone_lab.hidden=YES;
        map_cell.My_Map.hidden=YES;
        self.Cancel_out.hidden=YES;
        
        return map_cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





- (IBAction)Cancel_btn:(UIButton *)sender {
    [mixPanel track:@"Reservations_Detail_Cancel" properties:logInDic];
    [HttpRequest postWithURLSession:reservation_book_cancel andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"reservationRecordId":@(Model.id)}]  andBlock:^(id response, NSError *error) {
        if (!error) {
            //result = 1;取消订单成功
            if(response[@"result"])
            {
               [URLSingleton sharedURLSingleton].isUpDateToday = YES;
                
                //list列表进入后 需要返传id
                if (_PopBack) {
                     _PopBack(Model.id);
                }
                //today／预定list 进入后 需要刷新
                if (_PopDVCBack) {
                    _PopDVCBack();
                }
                
                //more或者notification进入后
                if(_is_mores){
                    //more和notification进入 通知today刷新界面
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"NeedReloadVC" object:nil];
                
                    
                    //notification 进入后block控制跳转
                    BOOL isCAN=YES;
                    if(_PopNotification){
                        _PopNotification(isCAN);
                     }
                }
                


                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
    }];
    
    
}

- (IBAction)nav_back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end



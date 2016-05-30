//
//  NHReservationListViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHReservationListViewController.h"
#import "NHReservationListTableViewCell.h"
#import "NHReservationsHeaderViewController.h"
#import "NHReservationsDetailViewController.h"

#import "HttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UITableView+Refreshing.h"
#import "NHReservationOrdersListModel.h"
#import "Utility.h"
#import "UIScrollView+EmptyDataSet.h"
#define COUNT 10

@interface NHReservationListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *List_arr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation NHReservationListViewController
@synthesize tablelistview,List_arr,is_more,NotType_str;

- (void)viewDidLoad {
    [super viewDidLoad];
    List_arr=[[NSMutableArray alloc]init];
    //数据为空时候的tableview代理－>empty
    self.tablelistview.emptyDataSetSource = self;
    self.tablelistview.emptyDataSetDelegate = self;
    self.tablelistview.delegate=self;
    self.tablelistview.dataSource=self;
    
    self.title= [GDLocalizableClass getStringForKey:@"UPCOMING RESERVATIONS"] ;
    self.tablelistview.backgroundColor=RGBACOLOR(245, 247, 249, 1);

    [self update];

}
-(void)update{
    @weakify(self)
    [self.tablelistview setRefreshing:^(bool isPull) {
        @strongify(self)
        if (isPull) {
            self.page = 1;
        }
        else
        {
            self.page++;
        }
        
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.page),@"count":@(COUNT)}];
        if (self.NotType_str!=nil&&self.NotType_str.length>0) {
            [attr setObject:self.NotType_str forKey:@"queryUnit"];
        }
        @weakify(self)
        [HttpRequest getWithUrl:today_reservationRecords andViewContoller:self andHudMsg:nil andAttributes:attr andBlock:^(id response, NSError *error) {
            @strongify(self)
            if (!error) {
                //预定列表
                NSArray *temp=[[NSArray alloc]init];
                temp = [MTLJSONAdapter modelsOfClass:[NHReservationOrdersListModel class] fromJSONArray:response[@"result"] error:nil];
                
                if (isPull)
                {
                    self.List_arr = [NSMutableArray arrayWithArray:temp];
                }
                else
                {
                    [self.List_arr addObjectsFromArray:temp];
                }
                
                [self.tablelistview endTableViewRefreshing:isPull andisHiddenFooter:temp.count<COUNT];
            }

        }];
    }];
    [self.tablelistview.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

       return List_arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *v1tableviewcell = @"NHReservationListTableViewCell";
//    NSUInteger section = [indexPath section];

    NHReservationListTableViewCell *cell = [tablelistview dequeueReusableCellWithIdentifier:v1tableviewcell forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:RGBACOLOR(245, 247, 249, 1)];

    if (List_arr.count!=0)
    {
        NHReservationOrdersListModel *model=List_arr[indexPath.row];
        cell.ReservationOrdersListModel=model;
        
        //取消预定按钮
        @weakify(cell)
        @weakify(self)
        [cell setCancelActionBlock:^(UIButton *btn){
            
            @strongify(cell)
            @strongify(self)
            NSIndexPath *index = [tableView indexPathForCell:cell];
            NHReservationOrdersListModel *Omodel=self.List_arr[index.row];
            
            [HttpRequest postWithURLSession:reservation_book_cancel andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"reservationRecordId":@(Omodel.id)}]  andBlock:^(id response, NSError *error) {
                if (!error) {
                    
                    if(response[@"result"])
                    {
                        if (self.List_arr.count>1){
                            //                            NSLog(@">1");
                            [self.List_arr removeObjectAtIndex:index.row];
                            [tablelistview deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
                            if(_PopddsBack)
                            {
                                (_PopddsBack)(self.List_arr);
                            }
                            _is_Cancel=YES;

                        }
                        else if(self.List_arr.count==1){
                            //                            NSLog(@"=1");
                            [self.List_arr removeAllObjects];
                            [self.tablelistview reloadData];
                            if(_PopddsBack)
                            {
                                (_PopddsBack)(self.List_arr);
                            }
                            _is_Cancel=YES;

                        }
                        else{
                            //                            NSLog(@"<1");
                        }
                        
                    }else{
                        //                        NSLog(@"取消订单失败");
                    }
                }
                else{
                    [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
                }
            }];
            
        }];
        
        return cell;
    }
    else{
        //如果一张订单都没有
        cell.title_name.text =[GDLocalizableClass getStringForKey:@"No reservation"];
        cell.background_view.backgroundColor=[UIColor whiteColor];
        cell.top_time_label.text=@"";
        cell.bottom_tim_label.text=@"";
        cell.time_label.text=@"0:00-0:00";
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [mixPanel track:@"Reservations_listClick" properties:logInDic];

    if (List_arr.count!=0) {
        NHReservationsDetailViewController* DetailVC=(NHReservationsDetailViewController*)[Utility pushViewControllerWithStoryboard:@"NHReservations" andViewController:@"NHReservationsDetailViewController" andParent:self];
        
        NHReservationOrdersListModel *model=List_arr[indexPath.row];
        DetailVC.Reservation_id=model.id;
        if (is_more) {
            DetailVC.is_mores=YES;
        }
        //订单详情取消后 返回当前界面后刷新
        @weakify(self)
        [DetailVC setPopBack:^(NSInteger Model_id){
            @strongify(self)
            if (model.id==Model_id) {
                [self.List_arr removeObjectAtIndex:indexPath.row];
                [tablelistview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }            
        }];
        
        [DetailVC setPopDVCBack:^{
//            NSLog(@"刷新出背景图");
            [self.tablelistview reloadData];
        }];
        

    }else{
        
//        NSLog(@"没有订单");
    }
    

}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    UIColor *need_color = RGBACOLOR(136, 139, 144, 1);

    NSString *testStr = [GDLocalizableClass getStringForKey:@"You have no reservation currently"];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    NSDictionary *attribs = @{
                              NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:18],
                              NSParagraphStyleAttributeName:ps,
                              NSForegroundColorAttributeName:need_color
                              };
    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:testStr attributes:attribs];

    return attributedText;
}

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//    
//}

/**
 Asks the data source for the image of the dataset.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noReservations"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)back:(id)sender {
    if (is_more) {
        //NSLog(@"more进入");
        if(_is_Cancel){
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NeedReloadVC" object:nil];
            
            [URLSingleton sharedURLSingleton].isUpDateToday = YES;
        }

    }else{
        //today 进入
    }
    [self.navigationController popViewControllerAnimated:YES];
}







@end












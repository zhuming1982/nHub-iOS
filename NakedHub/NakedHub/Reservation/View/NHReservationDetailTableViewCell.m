//
//  NHReservationDetailTableViewCell.m
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHReservationDetailTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyMapAnnotation.h"
#import "LocationManager.h"
#import "JXMapNavigationView.h"

@implementation NHReservationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /*
    [self.My_Map setRegion:MKCoordinateRegionMakeWithDistance([LocationManager shared].userLocation.coordinate, 3200.0, 3200.0)];
    [self.My_Map addAnnotation:[[MyMapAnnotation alloc]initWithImage:[UIImage imageNamed:@"iconMapPin"] andDetail:@"" andDetail:[LocationManager shared].userLocation.coordinate]];
     */
}

//赋值-NHReservationOrdersListModel
-(void)setReservationOrdersListModel:(NHReservationOrdersListModel *)ReservationOrdersListModel{
    _ReservationOrdersListModel=ReservationOrdersListModel;
    
    //公司图片
 /*   NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.hub.picture];
    [self.TOP_imageVIew sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];*/
    
    
    if ([_ReservationOrdersListModel.reservationType isEqualToString:@"HOTDESK"]||[_ReservationOrdersListModel.reservationType isEqualToString:@"FIXEDSEAT"]) {
        //workspace
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.hub.picture];
        [self.TOP_imageVIew sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }else{
        //workroom
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.meetingRoom.picture];
        [self.TOP_imageVIew sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }
    
    
    //公司名字
    NSString *meetname_str=_ReservationOrdersListModel.meetingRoom.name;
    if([_ReservationOrdersListModel.reservationType isEqualToString:@"HOTDESK"]||[_ReservationOrdersListModel.reservationType isEqualToString:@"FIXEDSEAT"]){
        meetname_str=[NSString stringWithFormat:@"\n%@",[GDLocalizableClass getStringForKey:@"Workspace"]];
    }else{
        meetname_str=[NSString stringWithFormat:@"\n%@",_ReservationOrdersListModel.meetingRoom.name];
    }
    self.title_label.text =[NSString stringWithFormat:@"%@%@",_ReservationOrdersListModel.hub.name,meetname_str];
    
    //日期
    NSDate *mounth_date = [NSDate dateWithTimeIntervalSince1970:[@(_ReservationOrdersListModel.startTime).stringValue doubleValue] / 1000];
    self.date_lab.text=[Utility get_book_YYYYMMDD:mounth_date];
    
    //时间
    NSString *start_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.startTime];
    NSString *end_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.endTime];
    NSString *start_end=[NSString stringWithFormat:@"%@ - %@",start_hour,end_hour];
    self.time_label.text=start_end;
    //地址
    self.address_lab.text=_ReservationOrdersListModel.hub.address;
    //电话
    self.phone_lab.text=_ReservationOrdersListModel.hub.phone;
    
    
    
    //电话点击事件
    if (_ReservationOrdersListModel.hub.phone!=nil&&_ReservationOrdersListModel.hub.phone.length!=0) {
        UITapGestureRecognizer *tepTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchtep)];
        [self.phone_lab addGestureRecognizer:tepTap];
    }
    //点击事件
    if (_ReservationOrdersListModel.hub.address!=nil&&_ReservationOrdersListModel.hub.address.length!=0) {
        UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAddress)];
        [self.address_lab addGestureRecognizer:addressTap];
    }
    
    //设置代理
    self.My_Map.delegate=self;
    //设置地图类型
    self.My_Map.mapType=MKMapTypeStandard;
    CLLocationCoordinate2D theCoordinate;
    //插入数据
    theCoordinate.latitude=_ReservationOrdersListModel.hub.location.latitude;
    theCoordinate.longitude=_ReservationOrdersListModel.hub.location.longitude;
    //设定显示范围
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    //设置地图显示的中心及范围
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    //设置地图显示的类型及根据范围进行显示
    [self.My_Map setMapType:MKMapTypeStandard];
    [self.My_Map setRegion:theRegion];
    //添加大头针
    [self addAnnotationCell_view:self.My_Map];
    

}

- (void) touchtep
{
    //    NSLog(@"touchtep");
    [mixPanel track:@"Reservations_Detail_Phone" properties:logInDic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_ReservationOrdersListModel.hub.phone]]];
}
- (void) touchAddress
{
    //    NSLog(@"touchAddress");
    [mixPanel track:@"Reservations_Detail_Address" properties:logInDic];
    JXMapNavigationView *vc = [[JXMapNavigationView alloc] init];
    [vc showMapNavigationViewFormcurrentLatitude:[LocationManager shared].userLocation.coordinate.latitude currentLongitute:[LocationManager shared].userLocation.coordinate.longitude TotargetLatitude:_ReservationOrdersListModel.hub.location.latitude targetLongitute:_ReservationOrdersListModel.hub.location.longitude toName:_ReservationOrdersListModel.hub.address];
    [self addSubview:vc];
}


#pragma mark 添加大头针
-(void)addAnnotationCell_view:(MKMapView *)cell_view{
    
    double  latitude_dou=_ReservationOrdersListModel.hub.location.latitude;
    double  location_dou=_ReservationOrdersListModel.hub.location.longitude;
    
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(latitude_dou, location_dou);
    
    MyMapAnnotation *annotation1=[[MyMapAnnotation alloc]init];
    //    annotation1.title=Model.hub.name;
    //    annotation1.subtitle=Model.hub.address;
    annotation1.coordinate=location1;
    annotation1.image=[UIImage imageNamed:@"iconMapPin"];
    
    
    [cell_view addAnnotation:annotation1];
    
}

//重写大头针
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MyMapAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[self.My_Map dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconMapPin"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((MyMapAnnotation *)annotation).image;//设置大头针视图的图片
        
        
        return annotationView;
    } else {
        return nil;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationKey"];
//    if (!annotationView) {
//        annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationKey"];
//    }
//    annotationView.annotation=annotation;
//    annotationView.image= [UIImage imageNamed:@"iconMapPin"];
//    return annotationView;
//}


@end







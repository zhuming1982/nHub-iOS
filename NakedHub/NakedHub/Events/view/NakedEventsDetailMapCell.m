//
//  NakedEventsDetailMapCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailMapCell.h"

#import "MyMapAnnotation.h"
#import "NakedEventsDetailModel.h"

@interface NakedEventsDetailMapCell ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation NakedEventsDetailMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [Utility configSubView:_mapView CornerWithRadius:4.0];
}

- (void)setEventsDetailModel:(NakedEventsDetailModel *)eventsDetailModel
{
    _eventsDetailModel = eventsDetailModel;
    // 31.14, 121.29 上海市中心经纬度
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(_eventsDetailModel.hub.location.latitude, _eventsDetailModel.hub.location.longitude), 1600.0, 1600.0)];
    ;
    [self.mapView addAnnotation:[[MyMapAnnotation alloc]initWithImage:[UIImage imageNamed:@"iconMapPin"] andDetail:@"" andDetail:CLLocationCoordinate2DMake(_eventsDetailModel.hub.location.latitude, _eventsDetailModel.hub.location.longitude)]];
    
    _addressLabel.text = _eventsDetailModel.hub.address;
    _telephoneLabel.text = _eventsDetailModel.hub.phone;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationKey"];
    if (!annotationView) {
        annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationKey"];
    }
    annotationView.annotation=annotation;
    annotationView.image= [UIImage imageNamed:@"iconMapPin"];
    return annotationView;
}

@end

//
//  NakedBookWorkSpaceMapCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/8.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookWorkSpaceMapCell.h"
#import "Constant.h"

#import "MyMapAnnotation.h"

@implementation NakedBookWorkSpaceMapCell

- (void)setHubModel:(NakedHubModel *)hubModel
{
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(hubModel.location.latitude, hubModel.location.longitude), 1600.0, 1600.0)];
    ;
    [self.mapView addAnnotation:[[MyMapAnnotation alloc]initWithImage:[UIImage imageNamed:@"iconMapPin"] andDetail:@"" andDetail:CLLocationCoordinate2DMake(hubModel.location.latitude, hubModel.location.longitude)]];
    _nameLabel.text = hubModel.name;
    _addressLabel.text = hubModel.address;
    _phoneNumberLabel.text = hubModel.phone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

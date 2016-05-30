//
//  MyMapAnnotation.h
//  NakedHub
//
//  Created by 施豪 on 16/4/6.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyMapAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;
#pragma mark 大头针详情描述
@property (nonatomic,copy) NSString *detail;


-(instancetype)initWithImage:(UIImage*)img
                   andDetail:(NSString*)detail
                   andDetail:(CLLocationCoordinate2D)coordinate;


@end

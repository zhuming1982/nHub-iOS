//
//  MyMapAnnotation.m
//  NakedHub
//
//  Created by 施豪 on 16/4/6.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "MyMapAnnotation.h"

@implementation MyMapAnnotation


-(instancetype)initWithImage:(UIImage*)img
                   andDetail:(NSString*)detail
                   andDetail:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        
    }
    _image = img;
    _detail = detail;
    _coordinate = coordinate;
    return self;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}

- (void)dealloc{
    
}


@end

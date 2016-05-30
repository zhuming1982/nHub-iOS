//
//  NHCountryCodeMode.h
//  NakedHub
//
//  Created by 施豪 on 16/3/24.
//  Copyright © 2016年 zhuming. All rights reserved.
//
//"id": 4,
//"name": "阿富汗",
//"level": "COUNTRY",
//"phoneCode": "93",
//"index": "A"

//"ext": {},
//"id": 0,
//"index": "string",
//"level": "COUNTRY",
//"name": "string",
//"phoneCode": "string",
//"version": 0

#import <Mantle/Mantle.h>

@interface NHCountryCodeMode : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) NSInteger    id;
@property (nonatomic,copy)   NSString      *name;
@property (nonatomic,copy)   NSString      *level;
@property (nonatomic,copy)   NSString      *phoneCode;
@property (nonatomic,copy)   NSString      *index;


@end

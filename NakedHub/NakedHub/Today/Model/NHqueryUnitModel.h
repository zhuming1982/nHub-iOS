//
//  NHqueryUnitModel.h
//  NakedHub
//
//  Created by 施豪 on 16/5/10.
//  Copyright © 2016年 zhuming. All rights reserved.
//
//{
//    "code": 200,
//    "result": [
//               {
//                   "name": "今天",
//                   "queryUnit": "TODAY"
//               },
//               {
//                   "name": "明天",
//                   "queryUnit": "TOMORROW"
//               },
//               {
//                   "name": "一周内",
//                   "queryUnit": "THE_WEEK"
//               },
//               {
//                   "name": "下周",
//                   "queryUnit": "NEXT_WEEK"
//               }
//               ]
//}

#import <Mantle/Mantle.h>

@interface NHqueryUnitModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString   *name;//要显示的内容
@property (nonatomic,copy) NSString   *queryUnit;



@end

















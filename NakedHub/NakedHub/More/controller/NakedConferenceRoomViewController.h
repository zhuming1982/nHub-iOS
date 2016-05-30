//
//  NakedConferenceRoomViewController.h
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedBookRoomModel.h"

@interface NakedConferenceRoomViewController : UIViewController

@property (nonatomic,strong) NSDate *selectDate;

@property (nonatomic,strong)NakedBookRoomModel *bookRoomModel;

@property (nonatomic,copy) NSString *cancelRule;
@property (nonatomic,copy) void (^ConferenceRoomSucessCallBack)();

@end

//
//  NotificationsTableViewCell.m
//  NakedHub
//
//  Created by 施豪 on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NotificationsTableViewCell.h"

@implementation NotificationsTableViewCell

- (void)awakeFromNib {

    [Utility configSubView:_red_image CornerWithRadius:_red_image.frame.size.width/2];
    [Utility configSubView:_Left_image CornerWithRadius:_Left_image.frame.size.width/2];

}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    //    //顶部分割线
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
    //底部分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220/255.0f green:220/255.0f blue:223/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height -0.5, rect.size.width, 0.5));
    
}
//赋值-NotificationsModel
-(void)setNotificationsModel:(NHNotificationsModel *)NotificationsModel{
    _NotificationsModel=NotificationsModel;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//显示箭头

    self.Title_label.text=_NotificationsModel.body;
    self.Time_label.text = _NotificationsModel.postTime;
    NSURL *Logo_imageUrl = [NSURL URLWithString:_NotificationsModel.showPicture];
    self.red_image.backgroundColor =_NotificationsModel.read?[UIColor clearColor]:            RGBACOLOR(38, 171, 240, 1);

    //默认加载图片控制
    //用户评论点赞
    if ([_NotificationsModel.pushSign isEqualToString:@"FEED_COMMENT"]||[_NotificationsModel.pushSign isEqualToString:@"FEED_LIKE"]||[_NotificationsModel.pushSign isEqualToString:@"FEED_FOLLOWER_POST"]||[_NotificationsModel.pushSign isEqualToString:@"COMMENT_LIKE"]) {
        
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"iconGenderMOff"]];
    }
    //用户关注
    else if ([_NotificationsModel.pushSign isEqualToString:@"USER_FOLLOW"]){
        
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"iconGenderMOff"]];
    }
    //预定记录详情
    //ROOM
    else if ([_NotificationsModel.pushSign isEqualToString:@"RESERVATION_CONFIRM"]||[_NotificationsModel.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_START"]||[_NotificationsModel.pushSign isEqualToString:@"RESERVATION_MEETINGROOM_UPCOMING"]){
        
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"leftWorkingroom"]];
    }
    //WORKSPACE
    else if([_NotificationsModel.pushSign isEqualToString:@"RESERVATION_WORKSPACE_CONFIRM_START"]||[_NotificationsModel.pushSign isEqualToString:@"RESERVATION_WORKSPACE_UPCOMING"]||[_NotificationsModel.pushSign isEqualToString:@"RESERVATION_WORKSPACE_START"]){
        
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"leftWorkSpace"]];
    }
    else{
        
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"leftWorkingroom"]];
    }

    
    
}
//赋值-NHReservationOrdersListModel
-(void)setReservationOrdersListModel:(NHReservationOrdersListModel *)ReservationOrdersListModel{
    _ReservationOrdersListModel=ReservationOrdersListModel;
   NSString *meetname_str=_ReservationOrdersListModel.meetingRoom.name;
    if ([_ReservationOrdersListModel.reservationType isEqualToString:@"HOTDESK"]||[_ReservationOrdersListModel.reservationType isEqualToString:@"FIXEDSEAT"]) {
        //workspace
        meetname_str=[NSString stringWithFormat:@"\n%@",[GDLocalizableClass getStringForKey:@"Workspace"]];
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.hub.picture];
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }else{
        //workroom
         meetname_str=[NSString stringWithFormat:@"\n%@",_ReservationOrdersListModel.meetingRoom.name];
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.meetingRoom.picture];
        [self.Left_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }
    
    
    self.Title_label.text =[NSString stringWithFormat:@"%@%@",_ReservationOrdersListModel.hub.name,meetname_str];
    //月
    //            NSInteger mounth=[[Utility getMonthWithInt:model.startTime]intValue];
    NSDate *mounth_date = [NSDate dateWithTimeIntervalSince1970:[@(_ReservationOrdersListModel.startTime).stringValue doubleValue] / 1000];
    //日
    NSString *day=[Utility getDayWithInt:_ReservationOrdersListModel.startTime];
    //开始－结束 时间点
    NSString *start_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.startTime];
    NSString *end_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.endTime];
    NSString *start_end=[NSString stringWithFormat:@"%@%@, %@ - %@",[Utility getMonth:mounth_date],day,start_hour,end_hour];
    self.Time_label.text = start_end;
    
    //图片
    
    self.red_image.backgroundColor =[UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

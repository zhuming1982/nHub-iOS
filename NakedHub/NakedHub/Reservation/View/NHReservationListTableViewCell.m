//
//  NHReservationListTableViewCell.m
//  NakedHub
//
//  Created by 施豪 on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHReservationListTableViewCell.h"

@implementation NHReservationListTableViewCell

- (void)awakeFromNib {
    //圆角
//    [self layoutRadiusCellimage:self.bot_image Cellview:self.background_view];
    
    [Utility configSubView:_showview CornerWithRadius:5.0];
//    [Utility configSubView:_bot_image CornerWithRadius:5.0];
//    [Utility configSubView:_background_view CornerWithRadius:5.0];

    CALayer *layer = [_showview layer];
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.2;
    
    //阴影
    self.showview.backgroundColor=[UIColor colorWithRed:245/255.0 green:247/255.0 blue:249/255.0 alpha:1];
//    self.showview.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.showview.layer.shadowOffset = CGSizeMake(0, 1);
//    self.showview.layer.shadowOpacity = 0.5;
//    self.showview.layer.shadowRadius = 2.0;
//    self.showview.layer.cornerRadius = 2.0;
    
    if([Utility isiPhone4]||[Utility isiPhone5]){
        self.left_space.constant = 15;
    }else{
        self.left_space.constant = 30;
    }
    [_cancel_btn setTitle:[GDLocalizableClass getStringForKey:@"CANCEL"]  forState:UIControlStateNormal];//设置button的title

}

-(void)layoutRadiusCellimage:(UIImageView *)cellimage Cellview:(UIView *)cellview{
    //VIEW 圆角
    cellview.layer.masksToBounds = YES;
    UIBezierPath *maskPath_view = [UIBezierPath bezierPathWithRoundedRect:cellimage.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer_view = [[CAShapeLayer alloc] init];
    maskLayer_view.frame = cellview.bounds;
    maskLayer_view.path = maskPath_view.CGPath;
    cellview.layer.mask = maskLayer_view;
    
    //image 圆角
    cellimage.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellimage.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cellimage.bounds;
    maskLayer.path = maskPath.CGPath;
    cellimage.layer.mask = maskLayer;

}

//赋值-NHReservationOrdersListModel
-(void)setReservationOrdersListModel:(NHReservationOrdersListModel *)ReservationOrdersListModel{
    _ReservationOrdersListModel=ReservationOrdersListModel;
    
    NSString *meetname_str=_ReservationOrdersListModel.meetingRoom.name;
    
    //判断字段meetingRoom.name 没有即是Workspace
    if([_ReservationOrdersListModel.reservationType isEqualToString:@"HOTDESK"]||[_ReservationOrdersListModel.reservationType isEqualToString:@"FIXEDSEAT"]){
        meetname_str=[NSString stringWithFormat:@"\n%@",[GDLocalizableClass getStringForKey:@"Workspace"]];
    }else{
        meetname_str=[NSString stringWithFormat:@"\n%@",_ReservationOrdersListModel.meetingRoom.name];
    }
    self.title_name.text =[NSString stringWithFormat:@"%@%@",_ReservationOrdersListModel.hub.name,meetname_str];
    self.background_view.backgroundColor=[UIColor whiteColor];
    //开始月
    //        long long month=[[Utility getMonthWithInt:model.startTime]intValue];
    NSDate *mounth_date = [NSDate dateWithTimeIntervalSince1970:[@(_ReservationOrdersListModel.startTime).stringValue doubleValue] / 1000];
    
    //开始日
    NSString *day=[Utility getDayWithInt:_ReservationOrdersListModel.startTime];
    //开始－结束 时间点
    NSString *start_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.startTime];
    NSString *end_hour=[Utility getHourMinuteWithInt:_ReservationOrdersListModel.endTime];
    
    NSString *start_end=[NSString stringWithFormat:@"%@ - %@",start_hour,end_hour];
    
    self.top_time_label.text=day;
    self.bottom_tim_label.text=[Utility getMonth:mounth_date];
    self.time_label.text=start_end;
    if ([_ReservationOrdersListModel.reservationType isEqualToString:@"HOTDESK"]||[_ReservationOrdersListModel.reservationType isEqualToString:@"FIXEDSEAT"]) {
        //workspace
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.hub.picture];
        [self.bot_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }else{
        //workroom
        NSURL *Logo_imageUrl = [NSURL URLWithString:_ReservationOrdersListModel.meetingRoom.picture];
        [self.bot_image sd_setImageWithURL:Logo_imageUrl placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Cancel_act:(id)sender {
    [mixPanel track:@"Reservations_Cancel" properties:logInDic];
    if(_CancelActionBlock)
    {
        _CancelActionBlock(sender);
    }
}
@end

//
//  NakedEventsDetailInfoCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsDetailInfoCell.h"

#import "KTCenterFlowLayout.h"
#import "NakedEventsDetailInfoCollectionViewCell.h"
#import "NakedEventsDetailModel.h"
#import "NakedEventsAttendeesModel.h"

@interface NakedEventsDetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel; // 日期

@property (weak, nonatomic) IBOutlet UILabel *eventLabel; // 活动

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottom;

@end

@implementation NakedEventsDetailInfoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    KTCenterFlowLayout *layout = [[KTCenterFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向

    if ([Utility isiPhone4] || [Utility isiPhone5]) {
        [layout setMinimumInteritemSpacing:5.f]; // item间距(最小值)
    } else if ([Utility isiPhone6]) {
        [layout setMinimumInteritemSpacing:6.f]; // item间距(最小值)
    } else {
        [layout setMinimumInteritemSpacing:7.f]; // item间距(最小值)
    }
    
    [layout setMinimumLineSpacing:0.f]; // 行间距(最小值)
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 8)]; //设置section的边距
    [layout setItemSize:CGSizeMake(44, 44)]; // item的大小
    self.collectionView.collectionViewLayout = layout;
//    self.collectionView.backgroundColor = [UIColor orangeColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEventsDetailModel:(NakedEventsDetailModel *)eventsDetailModel
{
    _eventsDetailModel = eventsDetailModel;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[@(_eventsDetailModel.startTime).stringValue doubleValue] / 1000];
    _dateLabel.text = [Utility get_DDMMYYYY:startDate];
    
    _eventLabel.text = _eventsDetailModel.title;
    _eventLabel.numberOfLines = 0;
    
    //开始－结束 时间点
    NSString *start_hour = [Utility getHourMinuteWithInt:_eventsDetailModel.startTime];
    NSString *end_hour = [Utility getHourMinuteWithInt:_eventsDetailModel.endTime];
    
    NSString *start_end = [NSString stringWithFormat:@"%@ - %@",start_hour,end_hour];
    _timeLabel.text = start_end;
}

- (void)setAttendeesList:(NSArray *)attendeesList
{
    _attendeesList = attendeesList;
    
    if (0 == _attendeesList.count) {
        _collectionViewHeight.constant = 0;
        _collectionViewTop.constant = 0;
        _collectionViewBottom.constant = 0;
    } else {
        if ([Utility isiPhone4] || [Utility isiPhone5]) {
            _collectionViewHeight.constant = 36.5;
        } else if ([Utility isiPhone6]) {
            _collectionViewHeight.constant = 44.5;
        } else {
            _collectionViewHeight.constant = 50;
        }
        _collectionViewTop.constant = 20;
        _collectionViewBottom.constant = 20;
    }
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _attendeesList.count >= 6 ? 6 : _attendeesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NakedEventsDetailInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nakedEventsDetailInfoCollectionViewCell" forIndexPath:indexPath];
    
    
    [cell.attendeesImageView sd_setImageWithURL:[NSURL URLWithString:_attendeesList[indexPath.row].portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    if (5 == indexPath.row && _eventsDetailModel.participatorCount >6) {
        cell.moreImgaeView.hidden = NO;
        cell.countLabel.hidden = NO;
    } else {
        cell.moreImgaeView.hidden = YES;
        cell.countLabel.hidden = YES;

    }
    
//    cell.moreImgaeView.hidden = ((6 > _eventsDetailModel.participatorCount) && (5 != indexPath.row));
//    cell.countLabel.hidden = ((6 > _eventsDetailModel.participatorCount) && (5 != indexPath.row));
    cell.countLabel.text = @(_eventsDetailModel.participatorCount).stringValue;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* 6s 44.5  6p 50 5s 36.5 */
    CGFloat height = self.collectionView.frame.size.height;
    return CGSizeMake(height, height);
}

@end

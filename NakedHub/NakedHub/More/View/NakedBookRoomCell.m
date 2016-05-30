//
//  NakedBookRoomCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookRoomCell.h"
#import "NakedBookTimeCCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@implementation NakedBookRoomCell

-(void)setRoomModel:(NakedBookRoomModel *)roomModel
{
    _roomModel = roomModel;
    [_RoomImageView sd_setImageWithURL:[NSURL URLWithString:roomModel.picture] placeholderImage:[UIImage imageNamed:@"CompanyBackGroup"]];
    _bookNameLabel.text = roomModel.name;
    [_membersBtn setTitle:[NSString stringWithFormat:@" %@",@(roomModel.seats).stringValue] forState:UIControlStateNormal];
    [_FloorBtn setTitle:[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@" %li/F"],roomModel.floor] forState:UIControlStateNormal];
    [self.timeCollectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_bgView CornerWithRadius:5.0];
    
    CALayer *layer = [_bgShadowView layer];
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowRadius = 2.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.2;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scorllViewCallBack) {
        _scorllViewCallBack(scrollView.contentOffset);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _roomModel.reservationTimeUnites.count/2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NakedBookTimeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NakedBookTimeCCell" forIndexPath:indexPath];
    [cell setModel:_roomModel.reservationTimeUnites[indexPath.row*2] andHalfModel:_roomModel.reservationTimeUnites[indexPath.row*2+1]];
    
    return cell;
}

@end

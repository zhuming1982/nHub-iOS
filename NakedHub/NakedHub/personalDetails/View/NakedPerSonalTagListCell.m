//
//  NakedPerSonalTagListCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPerSonalTagListCell.h"
#import "tagListCCell.h"
#import "KTCenterFlowLayout.h"
#import "Constant.h"

@implementation NakedPerSonalTagListCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _wdithConstraint.constant = kScreenWidth-40;
    [self setNeedsLayout];
    KTCenterFlowLayout *layout = [[KTCenterFlowLayout alloc]init];
    [layout setMinimumInteritemSpacing:5.f];
    [layout setMinimumLineSpacing:5.f];
    [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.collectionView.collectionViewLayout = layout;
    
    [self.servicesLabel setText:[GDLocalizableClass getStringForKey:@"SERVICES"]];
    [self.addServicesBtn setTitle:[GDLocalizableClass getStringForKey:@"Add services offered..."] forState:UIControlStateNormal];
    [self.separateBtn setTitle:[GDLocalizableClass getStringForKey:@"separate with commas"] forState:UIControlStateNormal];
}
-(void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self.collectionView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    tagListCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagListCCell" forIndexPath:indexPath];
    cell.backgroundColor = _isSkills ?RGBACOLOR(38.0, 171.0, 240.0, 1.0):RGBACOLOR(255.0, 182.0, 0, 1.0);
    cell.titleLabel.text = _dataList[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect textRect = [_dataList[indexPath.row]
                       boundingRectWithSize:CGSizeMake(kScreenWidth-60, CGFLOAT_MAX)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:14]}
                       context:nil];
    return CGSizeMake(textRect.size.width+20, 28);
}

- (IBAction)editAction:(UIButton *)sender {
    [mixPanel track:@"Company_edit_services" properties:logInDic];
    if (_editCallBack) {
        _editCallBack();
    }
}
@end

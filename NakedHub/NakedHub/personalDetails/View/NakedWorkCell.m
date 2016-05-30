//
//  NakedWorkCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedWorkCell.h"

@implementation NakedWorkCell

-(void)setCompaniesDM:(NHCompaniesDetailsModel *)companiesDM
{
    _companiesDM = companiesDM;
    [_workImageView sd_setImageWithURL:[NSURL URLWithString:companiesDM.logo] placeholderImage:[UIImage imageNamed:@"CompanyIcon"]];
    _workNameLabel.text = companiesDM.name;
    _membersCountLabel.text = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%ld members"],(unsigned long)companiesDM.members.count];
    _memberPortraits = @[_memberPortrait1,_memberPortrait2,_memberPortrait3,_memberPortrait4];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    for (int i=0; i< MIN(_memberPortraits.count, companiesDM.members.count); i++) {
        [_memberPortraits[i] sd_setImageWithURL:[NSURL URLWithString:companiesDM.members[i].portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
        [Utility configSubView:_memberPortraits[i] CornerWithRadius:_memberPortraits[i].frame.size.width/2];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_workImageView CornerWithRadius:5.0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)moreAction:(UIButton *)sender {
    if (_selectMoreMember) {
        _selectMoreMember();
    }
}
@end

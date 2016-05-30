//
//  NakedEventsAttendeesCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsAttendeesCell.h"

#import "NakedEventsAttendeesModel.h"

@interface NakedEventsAttendeesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *attendeesImageView; // 参与者头像

@property (weak, nonatomic) IBOutlet UILabel *attendeesNameLabel; // 参与者名字

@property (weak, nonatomic) IBOutlet UILabel *attendeesWorkLabel; // 参与者工作

@property (weak, nonatomic) IBOutlet UILabel *attendeesHubLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendeesNameTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendeesWorkHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendeesHubHeight;

@end

@implementation NakedEventsAttendeesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [Utility configSubView:_attendeesImageView CornerWithRadius:27.0];
}

- (void)setAttendeesModel:(NakedEventsAttendeesModel *)attendeesModel
{
    _attendeesModel = attendeesModel;
    [_attendeesImageView sd_setImageWithURL:[NSURL URLWithString:_attendeesModel.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    _attendeesNameLabel.text = _attendeesModel.nickname;
    
    NSString *string;
    if (_attendeesModel.title == nil && _attendeesModel.company.name == nil && _attendeesModel.hub.name == nil) {
        /* '公司' at '职业', hub的 'name' 都为 nil */
        _attendeesNameTop.constant = 16;
        _attendeesWorkHeight.constant = 0;
        _attendeesHubHeight.constant = 0;
        
        _attendeesWorkLabel.text = @"";
        _attendeesHubLabel.text = @"";
    } else if(_attendeesModel.title == nil && _attendeesModel.company.name == nil && _attendeesModel.hub.name != nil) {
        /* '公司' at '职业' 为 nil, hub的 'name' 不为 nil */
        _attendeesNameTop.constant = 6;
        _attendeesWorkHeight.constant = 0;
        _attendeesHubHeight.constant = 19;
        
        _attendeesWorkLabel.text = @"";
        _attendeesHubLabel.text = _attendeesModel.hub.name;
    } else if ((_attendeesModel.title != nil && _attendeesModel.company.name == nil && _attendeesModel.hub.name != nil) || (_attendeesModel.title == nil && _attendeesModel.company.name != nil && _attendeesModel.hub.name != nil)) {
        /* '公司' 为 nil, '职业' 不为 nil, hub的 'name' 不为 nil || '公司' 不为 nil, '职业' 为 nil, hub的 'name' 不为 nil */
        _attendeesNameTop.constant = -2;
        _attendeesWorkHeight.constant = 19;
        _attendeesHubHeight.constant = 19;
        
        if (_attendeesModel.title != nil && _attendeesModel.company.name == nil) {
            string = _attendeesModel.title;
        } else {
            string = _attendeesModel.company.name;
        }
        
        _attendeesWorkLabel.text = string;
        _attendeesHubLabel.text = _attendeesModel.hub.name;
    } else if ((_attendeesModel.title != nil && _attendeesModel.company.name == nil && _attendeesModel.hub.name == nil) || (_attendeesModel.title == nil && _attendeesModel.company.name != nil && _attendeesModel.hub.name == nil)) {
        /* '公司' 为 nil, '职业' 不为 nil, hub的 'name' 为 nil || '公司' 不为 nil, '职业' 为 nil, hub的 'name' 为 nil */
        _attendeesNameTop.constant = 6;
        _attendeesWorkHeight.constant = 19;
        _attendeesHubHeight.constant = 0;
        
        if (_attendeesModel.title != nil && _attendeesModel.company.name == nil) {
            string = _attendeesModel.title;
        } else {
            string = _attendeesModel.company.name;
        }
        
        _attendeesWorkLabel.text = string;
        _attendeesHubLabel.text = @"";
    } else {
        /* '公司' '职业' 'hub 的 name' 都不为 nil */
        _attendeesNameTop.constant = -2;
        _attendeesWorkHeight.constant = 19;
        _attendeesHubHeight.constant = 19;
        
        string = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ at %@"], _attendeesModel.title, _attendeesModel.company.name];
        _attendeesWorkLabel.text = string;
        _attendeesHubLabel.text = _attendeesModel.hub.name;
    }

    
//    if (_attendeesModel.company.name == nil && _attendeesModel.hub.name == nil) {
//        _attendeesNameTop.constant = 16;
//        _attendeesWorkHeight.constant = 0;
//        _attendeesHubHeight.constant = 0;
//        
//        _attendeesWorkLabel.text = @"";
//        _attendeesHubLabel.text = @"";
//    } else if (_attendeesModel.company.name != nil && _attendeesModel.hub.name == nil) {
//        _attendeesNameTop.constant = 6;
//        _attendeesWorkHeight.constant = 19;
//        _attendeesHubHeight.constant = 0;
//        
//        _attendeesWorkLabel.text = _attendeesModel.company.name;
//        _attendeesHubLabel.text = @"";
//    } else if (_attendeesModel.company.name == nil && _attendeesModel.hub.name != nil) {
//        _attendeesNameTop.constant = 6;
//        _attendeesWorkHeight.constant = 0;
//        _attendeesHubHeight.constant = 19;
//
//        _attendeesWorkLabel.text = @"";
//        _attendeesHubLabel.text = _attendeesModel.hub.name;
//    } else {
//        _attendeesNameTop.constant = -2;
//        _attendeesWorkHeight.constant = 19;
//        _attendeesHubHeight.constant = 19;
//
//        _attendeesWorkLabel.text = _attendeesModel.company.name;
//        _attendeesHubLabel.text = _attendeesModel.hub.name;
//    }
}

@end

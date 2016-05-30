//
//  SearchMembersCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SearchMembersCell.h"

#import "NakedUserModel.h"

@interface SearchMembersCell ()

@property (weak, nonatomic) IBOutlet UIImageView *membersImageView;

@property (weak, nonatomic) IBOutlet UILabel *membersName;

@property (weak, nonatomic) IBOutlet UILabel *membersCompanies;

@property (weak, nonatomic) IBOutlet UILabel *membersHub;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyHeight; // 公司 Label 的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hubHeight; // hub Label 的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop; // name 的顶部, 以 membersImageView 为参照物

@end

@implementation SearchMembersCell

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
    
    [Utility configSubView:_membersImageView CornerWithRadius:27.0];
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
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:220.0 / 255.0f green:220.0 / 255.0f blue:223.0 / 255.0f alpha:0.5f].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

- (void)setSearchMembersModel:(NakedUserModel *)searchMembersModel
{
    _searchMembersModel = searchMembersModel;
    
    [_membersImageView sd_setImageWithURL:[NSURL URLWithString:_searchMembersModel.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    _membersName.text = _searchMembersModel.nickname;
    
    NSString *string;
    if (_searchMembersModel.title == nil && _searchMembersModel.company.name == nil && _searchMembersModel.hub.name == nil) {
        /* '公司' at '职业', hub的 'name' 都为 nil */
        _nameTop.constant = 16;
        _companyHeight.constant = 0;
        _hubHeight.constant = 0;
        
        _membersCompanies.text = @"";
        _membersHub.text = @"";
    } else if(_searchMembersModel.title == nil && _searchMembersModel.company.name == nil && _searchMembersModel.hub.name != nil) {
        /* '公司' at '职业' 为 nil, hub的 'name' 不为 nil */
        _nameTop.constant = 6;
        _companyHeight.constant = 0;
        _hubHeight.constant = 19;
        
        _membersCompanies.text = @"";
        _membersHub.text = _searchMembersModel.hub.name;
    } else if ((_searchMembersModel.title != nil && _searchMembersModel.company.name == nil && _searchMembersModel.hub.name != nil) || (_searchMembersModel.title == nil && _searchMembersModel.company.name != nil && _searchMembersModel.hub.name != nil)) {
        /* '公司' 为 nil, '职业' 不为 nil, hub的 'name' 不为 nil || '公司' 不为 nil, '职业' 为 nil, hub的 'name' 不为 nil */
        _nameTop.constant = -2;
        _companyHeight.constant = 19;
        _hubHeight.constant = 19;
        
        if (_searchMembersModel.title != nil && _searchMembersModel.company.name == nil) {
            string = _searchMembersModel.title;
        } else {
            string = _searchMembersModel.company.name;
        }
        
        _membersCompanies.text = string;
        _membersHub.text = _searchMembersModel.hub.name;
    } else if ((_searchMembersModel.title != nil && _searchMembersModel.company.name == nil && _searchMembersModel.hub.name == nil) || (_searchMembersModel.title == nil && _searchMembersModel.company.name != nil && _searchMembersModel.hub.name == nil)) {
        /* '公司' 为 nil, '职业' 不为 nil, hub的 'name' 为 nil || '公司' 不为 nil, '职业' 为 nil, hub的 'name' 为 nil */
        _nameTop.constant = 6;
        _companyHeight.constant = 19;
        _hubHeight.constant = 0;
        
        if (_searchMembersModel.title != nil && _searchMembersModel.company.name == nil) {
            string = _searchMembersModel.title;
        } else {
            string = _searchMembersModel.company.name;
        }
        
        _membersCompanies.text = string;
        _membersHub.text = @"";
    } else {
        /* '公司' '职业' 'hub 的 name' 都不为 nil */
        _nameTop.constant = -2;
        _companyHeight.constant = 19;
        _hubHeight.constant = 19;
        
        string = [NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%@ at %@"], _searchMembersModel.title, _searchMembersModel.company.name];
        _membersCompanies.text = string;
        _membersHub.text = _searchMembersModel.hub.name;
    }
    
    
//    if (_searchMembersModel.work == nil && _searchMembersModel.company.name == nil && _searchMembersModel.hub.name == nil) {
//        _nameTop.constant = 16;
//        _companyHeight.constant = 0;
//        _hubHeight.constant = 0;
//    } else {
//        if (_searchMembersModel.work == nil && _searchMembersModel.company.name == nil) {
//            _nameTop.constant = 16;
//            _companyHeight.constant = 0;
//            _hubHeight.constant = 19;
//        } else {
//            _nameTop.constant = -2;
//            _companyHeight.constant = 19;
//            _hubHeight.constant = 19;
//            if (_searchMembersModel.company.name != nil && _searchMembersModel.work != nil) {
//                string = [NSString stringWithFormat:@"%@ at %@", _searchMembersModel.work, _searchMembersModel.company.name];
//            } else {
//                if (_searchMembersModel.company.name != nil) {
//                    string = _searchMembersModel.company.name;
//                } else {
//                    string = _searchMembersModel.work;
//                }
//            }
//        }
//    }
}

@end

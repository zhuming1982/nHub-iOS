//
//  NHEditCompanyDetailsViewController.m
//  NakedHub
//
//  Created by 施豪 on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NHEditCompanyDetailsViewController.h"
#import "NakedPersonalDAboutMeCell.h"
#import "NakedPersonalDAccountCell.h"
#import "NakedPersonalDetailsTextCell.h"
#import "NakedTagListCell.h"
#import "NakedGenderCell.h"
#import "NakedBirthdayCell.h"
#import "NakedPerSonalTagListCell.h"
#import "NHComanyEditNameTableViewCell.h"

#import "HttpRequest.h"
#import "UITableView+Refreshing.h"
#import "UIImageView+WebCache.h"

#import "NakedPerSonalTableHeadSecionView.h"
#import "UINavigationBar+Awesome.h"
#import "NakedEditSkillsOrInterestViewController.h"
#import "RMDateSelectionViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"
#import "NHCompanyContentTableViewCell.h"

#define NAVBAR_CHANGE_POINT 50


@interface NHEditCompanyDetailsViewController ()<UITableViewDelegate>

@property (nonatomic,strong) NSArray *footSectionViews;
@property (nonatomic,strong) NakedPerSonalTagListCell *cell;
@property (nonatomic,strong) NSArray<NSArray*> *identifiers;
@property (nonatomic,strong) UIImage *HeadPortraitImage;
@property (nonatomic,strong) UIImage *backGroupImage;
@property (nonatomic,strong) NSArray *tableViewDateSoure;
@property (nonatomic,strong) NSMutableArray *Services;
@property (nonatomic,strong) NSMutableDictionary *atter;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backGroupImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CompanyPortraitView;

@end

@implementation NHEditCompanyDetailsViewController

@synthesize CompanyPortraitView;

//添加图片按钮
- (IBAction)editPortrait:(UIButton *)sender {
    
    [mixPanel track:@"Company_edit_portrait" properties:logInDic];
    
    [[self.tableView TPKeyboardAvoiding_findFirstResponderBeneathView:self.tableView] resignFirstResponder];
    
   UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
    
    actionsheet.tag = 1000;
    [actionsheet showInView:self.view];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    //返回提示用户保存
    [self showOkayCancelAlert];
}

-(void)newback{
    [self.navigationController popViewControllerAnimated:YES];
}
//背景点击事件

-(void)background_action{
    
    [mixPanel track:@"Company_edit_background" properties:logInDic];
    
    [[self.tableView TPKeyboardAvoiding_findFirstResponderBeneathView:self.tableView] resignFirstResponder];
    
   UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
    actionsheet.tag = 1001;
    [actionsheet showInView:self.view];
}


-(void)initSubViewData
{
    [_backGroupImageView sd_setImageWithURL:[NSURL URLWithString:_CompanyModel.background] placeholderImage:[UIImage imageNamed:@"userbackGroup"]];
    [CompanyPortraitView sd_setImageWithURL:[NSURL URLWithString:_CompanyModel.logo] placeholderImage:[UIImage imageNamed:@"Company Profile"]];
    
    [self initUserDateList];
}
-(void)initUserDateList
{
    NSString *Services = @"";
    if (_CompanyModel.services.count>0) {
        Services = _CompanyModel.services[0].name;
    }
    for (ExporeServicesModel *contactModel in _CompanyModel.services) {
        if (![contactModel.name isEqualToString:_CompanyModel.services[0].name]) {
            
            Services = [Services stringByAppendingString:[NSString stringWithFormat:@",%@",contactModel.name]];
        }
    }
    if(Services.length>0)
    {
        [self.atter setObject:Services forKey:@"services"];
    }
 
    _tableViewDateSoure = @[
                           
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"COMPANY NAME"],@"content":_CompanyModel.name?_CompanyModel.name:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"EMAIL"] ,@"content":_CompanyModel.email?_CompanyModel.email:@""}],
                               [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"PHONE"] ,@"content":_CompanyModel.phone?_CompanyModel.phone:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"WEBSITE"] ,@"content":_CompanyModel.website?_CompanyModel.website:@""}]],
                            //Section 2 What we do...
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"WHAT WE DO"],@"content":_CompanyModel.introduction?_CompanyModel.introduction:@""}]],
                            //Section 3 SERVICES...
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"SERVICES"] ,@"content":Services}]],
                            //Section 4 WECHAT...
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"WECHAT"],@"content":_CompanyModel.contact.wechat?_CompanyModel.contact.wechat:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"FACEBOOK"],@"content":_CompanyModel.contact.facebook?_CompanyModel.contact.facebook:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"TWITTER"] ,@"content":_CompanyModel.contact.twitter?_CompanyModel.contact.twitter:@""}]],
                            ];
    
    [self.tableView reloadData];

}

-(void)viewDidLayoutSubviews{

    CompanyPortraitView.layer.masksToBounds=YES;
    CompanyPortraitView.layer.cornerRadius=CompanyPortraitView.frame.size.width/10.0f; //设置圆
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    [self.saveBtn setTitle:[GDLocalizableClass getStringForKey:@"SAVE"] forState:UIControlStateNormal];
    
    _atter = [NSMutableDictionary dictionaryWithDictionary:@{@"id":@(_CompanyModel.id)}];

    NSMutableArray *tempViews = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NakedPerSonalTableHeadSecionView *v = [[NakedPerSonalTableHeadSecionView alloc]init];
        [v.titleLabel setHidden:YES];
        [tempViews addObject:v];
    }
    _footSectionViews = [NSArray arrayWithArray:tempViews];
    _identifiers = @[
  @[@"NHComanyEditNameTableViewCell",@"NHComanyEditNameTableViewCell",@"NHComanyEditNameTableViewCell",@"NHComanyEditNameTableViewCell"],
  @[@"NakedPersonalDAboutMeCell"],
  @[@"NakedPerSonalTagListCell"],
@[@"NHCompanyContentTableViewCell",@"NHCompanyContentTableViewCell",@"NHCompanyContentTableViewCell"]];
    
    [self initSubViewData];

    _backGroupImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(background_action)];
    [_backGroupImageView addGestureRecognizer:singleTap1];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor blackColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _footSectionViews.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _identifiers[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[indexPath.section][indexPath.row] forIndexPath:indexPath];
    //ID
//    [self.atter setObject:Details_ID forKey:@"id"];

    //Company
    if ([cell isKindOfClass:[NHComanyEditNameTableViewCell class]])
    {
        ((NHComanyEditNameTableViewCell*)cell).title.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        ((NHComanyEditNameTableViewCell*)cell).company_textView.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        NHComanyEditNameTableViewCell*ComanyEditName  = (NHComanyEditNameTableViewCell*)cell;

        @weakify(self)
        [[RACSignal merge:@[[ComanyEditName.company_textView rac_textSignal], RACObserve(ComanyEditName.company_textView, text)]] subscribeNext:^(NSString *text){
        @strongify(self)
            NSString *Key = @"";
            
            switch (indexPath.row) {
                case 0:
                {
                    [mixPanel track:@"Company_edit_companyName" properties:logInDic];
                    Key = @"name";
                    if (text.length>20)
                    {
                        ComanyEditName.company_textView.text = [text substringToIndex:20];
                    }
                }
                    break;
                case 1:
                {
                    [mixPanel track:@"Company_edit_email" properties:logInDic];
                    Key = @"email";
                    if (text.length>50)
                    {
                        ComanyEditName.company_textView.text = [text substringToIndex:50];
                    }
                }
                    break;
                case 2:
                {
                    [mixPanel track:@"Company_edit_phone" properties:logInDic];
                    Key = @"phone";
                    if (text.length>20)
                    {
                        ComanyEditName.company_textView.text = [text substringToIndex:20];
                    }
                }
                    break;
                case 3:
                {
                    [mixPanel track:@"Company_edit_website" properties:logInDic];
                    Key = @"website";
                    if (text.length>20)
                    {
                    ComanyEditName.company_textView.text = [text substringToIndex:20];
                    }
                }
                    break;
                default:
                    break;
            }
        
            NSDictionary *Dic = _tableViewDateSoure[indexPath.section][indexPath.row];
            [Dic setValue:ComanyEditName.company_textView.text forKeyPath:@"content"];
            [self.atter setObject:ComanyEditName.company_textView.text forKey:Key];

        }];
        
    }
    //About
    if ([cell isKindOfClass:[NakedPersonalDAboutMeCell class]])
    {
        NakedPersonalDAboutMeCell*DAboutMeCell  = (NakedPersonalDAboutMeCell*)cell;
        ((NakedPersonalDAboutMeCell*)cell).contentTextV.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        [[RACSignal merge:@[[DAboutMeCell.contentTextV rac_textSignal], RACObserve(DAboutMeCell.contentTextV, text)]] subscribeNext:^(NSString *text) {
            [mixPanel track:@"Company_edit_whatWeDo" properties:logInDic];
            if (text.length>160) {
                DAboutMeCell.contentTextV.text = [text substringToIndex:160];
                DAboutMeCell.textCountLabel.text = [NSString stringWithFormat:@"160/160"];
            }
            else
            {
                DAboutMeCell.textCountLabel.text = [NSString stringWithFormat:@"%lu/160",(unsigned long)DAboutMeCell.contentTextV.text.length];
            }
           
            [self.atter setObject:DAboutMeCell.contentTextV.text forKey:@"introduction"];
            _tableViewDateSoure[indexPath.section][indexPath.row][@"content"] = DAboutMeCell.contentTextV.text;
        }];
    }
    //AddServes
    if ([cell isKindOfClass:[NakedPerSonalTagListCell class]])
    {
        NSString *content = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        ((NakedPerSonalTagListCell*)cell).isSkills=YES;
        ((NakedPerSonalTagListCell*)cell).titleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        if (indexPath.section == 2) {

            if (content&&content.length>0) {
                ((NakedPerSonalTagListCell*)cell).dataList = [content componentsSeparatedByString:@","];
            }
        }
        @weakify(cell)
        @weakify(self)
        [((NakedPerSonalTagListCell*)cell) setEditCallBack:^{
            //编辑
            @strongify(cell)
            @strongify(self)
            NakedEditSkillsOrInterestViewController * EditSkillsOrInterestVC =(NakedEditSkillsOrInterestViewController*)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedEditSkillsOrInterestViewController" andParent:self];
            
            EditSkillsOrInterestVC.dataList = content.length?[[content componentsSeparatedByString:@","]mutableCopy]:[NSMutableArray array];
            EditSkillsOrInterestVC.title = [GDLocalizableClass getStringForKey:@"Edit Services"];
            [EditSkillsOrInterestVC setEditCallBack:^(NSString *str) {
                if(indexPath.section == 2)
                {
                    [self.atter setObject:str forKey:@"services"];
                }
                
                _tableViewDateSoure[indexPath.section][indexPath.row][@"content"] = str;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        }];
        [((NakedPerSonalTagListCell*)cell).collectionView reloadData];
    }
    //Content
    if ([cell isKindOfClass:[NHCompanyContentTableViewCell class]])
    {
        NHCompanyContentTableViewCell*CompanyContentCell  = (NHCompanyContentTableViewCell*)cell;
        
        CompanyContentCell.content_name_label.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        CompanyContentCell.contact_text.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        
        @weakify(self)
        [[RACSignal merge:@[[CompanyContentCell.contact_text rac_textSignal], RACObserve(CompanyContentCell.contact_text, text)]] subscribeNext:^(NSString *text) {
            @strongify(self)
  
            NSString *Key = @"";
            switch (indexPath.row) {
                case 0:
                {
                    [mixPanel track:@"Company_edit_wechat" properties:logInDic];
                    
                    Key = @"wechat";
                ((NHCompanyContentTableViewCell*)cell).left_image.image=[UIImage imageNamed:@"socialWechat"];
                ((NHCompanyContentTableViewCell*)cell).contact_text.placeholder = @"ID";

                }
                    break;
                case 1:
                {
                    [mixPanel track:@"Company_edit_facebook" properties:logInDic];
                    Key = @"facebook";
                    ((NHCompanyContentTableViewCell*)cell).left_image.image=[UIImage imageNamed:@"socialFacebook"];
                    ((NHCompanyContentTableViewCell*)cell).contact_text.placeholder = @"facebook.com/name";

                }
                    break;
                case 2:
                {
                    [mixPanel track:@"Company_edit_twitter" properties:logInDic];
                    Key = @"twitter";
                    ((NHCompanyContentTableViewCell*)cell).left_image.image=[UIImage imageNamed:@"socialTwitter"];
                    ((NHCompanyContentTableViewCell*)cell).contact_text.placeholder = @"@username";

                }
                    break;
                default:
                    break;
            }
            if (text.length>20) {
                CompanyContentCell.contact_text.text = [text substringToIndex:20];
            }
            
            NSDictionary *Dic = _tableViewDateSoure[indexPath.section][indexPath.row];
            [Dic setValue:CompanyContentCell.contact_text.text forKeyPath:@"content"];
            [self.atter setObject:CompanyContentCell.contact_text.text forKey:Key];
        }];
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _footSectionViews[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            return 168;
        }
            break;
        case 2:
        {
            if (_cell == nil)
            {
                _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell" ];
            }
            NSString *content = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
            _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell"];
            _cell.dataList = [content componentsSeparatedByString:@","];
            return _cell.collectionView.contentSize.height+65;
        }
            break;
            
        default:
            return 54;
            break;
    }
}

//didSelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- 相机代理方法
//Save
- (IBAction)Save_btn:(UIButton *)sender {
    [mixPanel track:@"Company_edit_save" properties:logInDic];
    NSMutableArray *images = [NSMutableArray array];
  
    
    if (_HeadPortraitImage) {
        [images addObject:@{@"key":@"logoFile",@"image":_HeadPortraitImage}];
    }
    if (_backGroupImage) {
        [images addObject:@{@"key":@"backgroundFile",@"image":_backGroupImage}];
    }

    //判断公司名为空
    NSString *name_space_str = [self.atter[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([name_space_str isEqualToString:@""]||name_space_str.length==0){
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Please enter your company name."]];
    }
    else{
            [HttpRequest upLoadWithUrl:company_manage andViewContoller:self andHudMsg:@"" andUploadImageName:@"file" andImages:images andAttributes:self.atter andBlock:^(id response, NSError *error) {
                if (!error) {
                    if (_updateCallBack) {
                        _updateCallBack();
                        [self newback];
                    }
                }
                else{
                    [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
                }
                
            }];
    }
}


//image_file
-(void)showImagePickerControllerWithPickerType:(UIImagePickerControllerSourceType)type andTag:(NSInteger)tag
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.view.tag = tag;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    
    [picker setSourceType:type];
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.view.tag == 1000) {
        CompanyPortraitView.image = [Utility imageByScalingToMaxSize:portraitImg];
        _HeadPortraitImage = [Utility imageByScalingToMaxSize:portraitImg];
    }
    else
    {
        _backGroupImageView.image = [Utility imageByScalingToMaxSize:portraitImg];
        _backGroupImage = [Utility imageByScalingToMaxSize:portraitImg];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showImagePickerControllerWithPickerType:UIImagePickerControllerSourceTypeCamera andTag:actionSheet.tag];
    }
    else if (buttonIndex == 1) {
        [self showImagePickerControllerWithPickerType:UIImagePickerControllerSourceTypePhotoLibrary andTag:actionSheet.tag];
    }
}


- (void)showOkayCancelAlert {
    
    NSString *title = [GDLocalizableClass getStringForKey:@"Confirm"];
    NSString *message = [GDLocalizableClass getStringForKey:@"Leave this page without saving?"];
    NSString *cancelButtonTitle = [GDLocalizableClass getStringForKey:@"Cancel"];
    NSString *otherButtonTitle = [GDLocalizableClass getStringForKey:@"OK"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end







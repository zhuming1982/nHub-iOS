//
//  NakedEditPerSonalDetailsViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEditPerSonalDetailsViewController.h"
#import "NakedPersonalDAboutMeCell.h"
#import "NakedPersonalDAccountCell.h"
#import "NakedPersonalDetailsTextCell.h"
#import "NakedTagListCell.h"
#import "NakedGenderCell.h"
#import "NakedLocationCell.h"
#import "NakedBirthdayCell.h"
#import "NakedPerSonalTagListCell.h"
#import "Utility.h"
#import "NakedPerSonalTableHeadSecionView.h"
#import "UINavigationBar+Awesome.h"
#import "RMDateSelectionViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"
#import "NakedHubSelectViewController.h"
#import "NakedEditSkillsOrInterestViewController.h"


#define NAVBAR_CHANGE_POINT 50
//@[@"Photography",@"Events",@"Head Shots",@"Video Editing",@"Wedding Photography",@"Editorial"]
@interface NakedEditPerSonalDetailsViewController ()<UITableViewDelegate>
@property (nonatomic,strong) NakedPerSonalTagListCell *cell;
@property (nonatomic,strong) NSArray *footSectionViews;

@property (nonatomic,strong) NSArray<NSArray*> *identifiers;
@property (weak, nonatomic) IBOutlet UIImageView *backGroupImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userPortraitView;
@property (nonatomic,strong) NSArray *tableViewDateSoure;
@property (nonatomic,strong) NSMutableDictionary *atter;
@property (nonatomic,strong) UIImage *HeadPortraitImage;
@property (nonatomic,strong) UIImage *backGroupImage;

@property (nonatomic,strong) NSMutableArray *Skills;
@property (nonatomic,strong) NSMutableArray *interests;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)editPortrait:(UIButton *)sender;
- (IBAction)editBackGroupView:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *getStartedBtn;


@end

@implementation NakedEditPerSonalDetailsViewController
- (IBAction)back:(UIBarButtonItem *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self showOkayCancelAlert];

}

-(void)newback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOkayCancelAlert {
    
    NSString *title = [GDLocalizableClass getStringForKey:@"Confirm"];
    NSString *message = [GDLocalizableClass getStringForKey:@"Leave this page without saving?"];
    NSString *cancelButtonTitle = [GDLocalizableClass getStringForKey:@"Cancel"];
    NSString *otherButtonTitle = [GDLocalizableClass getStringForKey:@"OK"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)initSubViewData
{
    [_backGroupImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.background] placeholderImage:[UIImage imageNamed:@"userbackGroup"]];
    [_userPortraitView sd_setImageWithURL:[NSURL URLWithString:_userModel.portait] placeholderImage:[UIImage imageNamed:@"bigUserIcon"]];
    [self initUserDateList];
    
}
-(void)initUserDateList
{
    
    _tableViewDateSoure = @[@[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"FULL NAME"],@"content":_userModel.nickname?_userModel.nickname:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"TITLE"],@"content":_userModel.title?_userModel.title:@""}],[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"COMPANY"],@"content":_userModel.company?_userModel.company.name:@""}]],
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"ABOUT ME"],@"content":_userModel.userDescription?_userModel.userDescription:@""}]],
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"LOCATION"],@"content":_userModel.hub.name?_userModel.hub.name:@""}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"BIRTHDAY"],@"content":_userModel.birthday == 0?@"":[Utility getYYYYMMDDWithInt:_userModel.birthday]}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"GENDER"],@"content":_userModel.gender?_userModel.gender:@""}]],
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"SKILLS"],@"content":_userModel.skills?_userModel.skills:@""}]],
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"INTERESTS"],@"content":_userModel.interests?_userModel.interests:@""}]],
                            @[[NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"WECHAT"],@"content":_userModel.contact.wechat?_userModel.contact.wechat:@"",@"img":@"socialWechat"}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"FACEBOOK"],@"content":_userModel.contact.facebook?_userModel.contact.facebook:@"",@"img":@"socialFacebook"}],
                              [NSMutableDictionary dictionaryWithDictionary:@{@"title":[GDLocalizableClass getStringForKey:@"TWITTER"],@"content":_userModel.contact.twitter?_userModel.contact.twitter:@"",@"img":@"socialTwitter"}]]];
    
    if(_userModel.skills&&_userModel.skills.length>0)
    {
        [self.atter setObject:_userModel.skills forKey:@"skills"];
    }
    
    if (_userModel.interests&&_userModel.interests.length>0) {
        [self.atter setObject:_userModel.interests forKey:@"interests"];
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Utility configSubView:self.userPortraitView CornerWithRadius:self.userPortraitView.frame.size.width/2];
    [Utility configSubView:self.addBtn CornerWithRadius:self.addBtn.frame.size.width/2];
}
- (void)skip
{
    [self showHudInView:self.view hint:@""];
    [Utility loginResultAndBlock:^(id response, EMError *error) {
        [self hideHud];
        if (!error) {
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
            [[UIApplication sharedApplication].delegate window].rootViewController = tabBarVC;
        }
        else
        {
            [Utility showErrorWithVC:self andMessage:error.description];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _atter = [NSMutableDictionary dictionary];
    [self initSubViewData];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.getStartedBtn setTitle:[GDLocalizableClass getStringForKey:@"SAVE"] forState:UIControlStateNormal];
    if (_isSign) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[GDLocalizableClass getStringForKey:@"skip"] style:UIBarButtonItemStylePlain target:self action:@selector(skip)];
        [self.getStartedBtn setTitle:[GDLocalizableClass getStringForKey:@"LET’S GO!"] forState:UIControlStateNormal];
    }
    
    
    
    _identifiers = @[@[@"NakedPersonalDetailsTextCell",@"NakedPersonalDetailsTextCell",@"NakedPersonalDetailsTextCell",@"lineCell"],
                     @[@"NakedPersonalDAboutMeCell",@"lineCell"],
                     @[@"NakedLocationCell",@"NakedBirthdayCell",@"NakedGenderCell",@"lineCell"],
                     @[@"NakedPerSonalTagListCell",@"lineCell"],
                     @[@"NakedPerSonalTagListCell",@"lineCell"],
                     @[@"NakedPersonalDAccountCell",@"NakedPersonalDAccountCell",@"NakedPersonalDAccountCell",@"lineCell"]];
    
    
    // Do any additional setup after loading the view.
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    NSLog(@"self.tableView.contentOffset.y = %f",self.tableView.contentOffset.y);
    if (self.tableView.contentSize.height-self.tableView.contentOffset.y<=self.tableView.frame.size.height)
    {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-5)];
    }
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _identifiers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _identifiers[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[indexPath.section][indexPath.row] forIndexPath:indexPath];
    if ([cell isKindOfClass:[NakedPersonalDetailsTextCell class]]) {
        NakedPersonalDetailsTextCell*PersonalDetailsTextCell  = (NakedPersonalDetailsTextCell*)cell;
        PersonalDetailsTextCell.titleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        PersonalDetailsTextCell.contentTextF.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        @weakify(self)
        [[RACSignal merge:@[[PersonalDetailsTextCell.contentTextF rac_textSignal], RACObserve(PersonalDetailsTextCell.contentTextF, text)]] subscribeNext:^(NSString *text)
        {
           @strongify(self)
            NSString *Key = @"";
            switch (indexPath.row) {
                case 0:
                {
                    [mixPanel track:@"User_edit_fullName" properties:logInDic];
                    Key = @"nickname";
                    
                }
                    break;
                case 1:
                {
                    [mixPanel track:@"User_edit_title" properties:logInDic];
                    Key = @"title";
                }
                    break;
                case 2:
                {
                    PersonalDetailsTextCell.contentTextF.userInteractionEnabled = NO;
                }
                    break;
                default:
                    break;
            }
            if (text.length>20) {
                PersonalDetailsTextCell.contentTextF.text = [text substringToIndex:20];
            }
        
            NSDictionary *Dic = _tableViewDateSoure[indexPath.section][indexPath.row];
            [Dic setValue:PersonalDetailsTextCell.contentTextF.text forKeyPath:@"content"];
            if (Key.length>0) {
                [self.atter setObject:PersonalDetailsTextCell.contentTextF.text forKey:Key];
            }
        }];
    }
    if ([cell isKindOfClass:[NakedPersonalDAccountCell class]]) {
        
        NakedPersonalDAccountCell*PersonalDAccountCell  = (NakedPersonalDAccountCell*)cell;
        NSString *p = nil;
        switch (indexPath.row) {
            case 0:
            {
                p = @"ID";
            }
                break;
            case 1:
            {
                p = @"facebook.com/name";
            }
                break;
            case 2:
            {
                p = @"@username";
            }
                break;
            default:
                break;
        }
        PersonalDAccountCell.accountContentTextF.placeholder = p;
        PersonalDAccountCell.accountNameLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        PersonalDAccountCell.accountContentTextF.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        @weakify(self)
        [[RACSignal merge:@[[PersonalDAccountCell.accountContentTextF rac_textSignal], RACObserve(PersonalDAccountCell.accountContentTextF, text)]] subscribeNext:^(NSString *text) {
            @strongify(self)
            NSString *Key = @"";
            switch (indexPath.row) {
                case 0:
                {
                    [mixPanel track:@"User_edit_wechat" properties:logInDic];
                    Key = @"wechat";
                }
                    break;
                case 1:
                {
                    [mixPanel track:@"User_edit_facebook" properties:logInDic];
                    Key = @"facebook";
                }
                    break;
                case 2:
                {
                    [mixPanel track:@"User_edit_twitter" properties:logInDic];
                    Key = @"twitter";
                }
                    break;
                default:
                    break;
            }
            if (text.length>20) {
                PersonalDAccountCell.accountContentTextF.text = [text substringToIndex:20];
            }
            NSDictionary *Dic = _tableViewDateSoure[indexPath.section][indexPath.row];
            [Dic setValue:PersonalDAccountCell.accountContentTextF.text forKeyPath:@"content"];
            [self.atter setObject:PersonalDAccountCell.accountContentTextF.text forKey:Key];
        }];
        ((NakedPersonalDAccountCell*)cell).accountIconView.image = [UIImage imageNamed:_tableViewDateSoure[indexPath.section][indexPath.row][@"img"]];
    }
    
    if ([cell isKindOfClass:[NakedPerSonalTagListCell class]]) {
        NSString *content = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        ((NakedPerSonalTagListCell*)cell).titleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        ((NakedPerSonalTagListCell*)cell).isSkills = indexPath.section == 3;
        if (indexPath.section == 3) {
            if (content&&content.length>0) {
                ((NakedPerSonalTagListCell*)cell).dataList = [content componentsSeparatedByString:@","];
//                ((NakedPerSonalTagListCell*)cell).isSkills = YES;
            }
        }
        else
        {
            if (content&&content.length>0) {
//                ((NakedPerSonalTagListCell*)cell).isSkills = NO;
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
            NSString *content = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
            if (content.length>0) {
                EditSkillsOrInterestVC.dataList = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@","]];
            }
            else{
                EditSkillsOrInterestVC.dataList = [NSMutableArray array];
            }
            
            if (((NakedPerSonalTagListCell*)cell).isSkills) {
                [mixPanel track:@"User_edit_skills" properties:logInDic];
            } else {
                [mixPanel track:@"User_edit_interests" properties:logInDic];
            }
            
            EditSkillsOrInterestVC.title = ((NakedPerSonalTagListCell*)cell).isSkills?[GDLocalizableClass getStringForKey:@"Edit Skills"]:[GDLocalizableClass getStringForKey:@"Edit Interest"];
            [EditSkillsOrInterestVC setEditCallBack:^(NSString *str) {
                if(indexPath.section == 3){
                    [self.atter setObject:str forKey:@"skills"];
                }
                else
                {
                    [self.atter setObject:str forKey:@"interests"];
                }
                _tableViewDateSoure[indexPath.section][indexPath.row][@"content"] = str;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];

        }];
//        [((NakedPerSonalTagListCell*)cell).collectionView reloadData];
    }

    if ([cell isKindOfClass:[NakedPersonalDAboutMeCell class]]) {
        NakedPersonalDAboutMeCell*PersonalDAboutMeCell  = (NakedPersonalDAboutMeCell*)cell;
        
        PersonalDAboutMeCell.aboutMelabel.text= _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        PersonalDAboutMeCell.contentTextV.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        [[RACSignal merge:@[[PersonalDAboutMeCell.contentTextV rac_textSignal], RACObserve(PersonalDAboutMeCell.contentTextV, text)]] subscribeNext:^(NSString *text) {
            if (text.length>160) {
                PersonalDAboutMeCell.contentTextV.text = [text substringToIndex:160];
            }
            
            [mixPanel track:@"User_edit_aboutMe" properties:logInDic];
            PersonalDAboutMeCell.textCountLabel.text = [NSString stringWithFormat:@"%lu/160",(unsigned long)PersonalDAboutMeCell.contentTextV.text.length];
            [self.atter setObject:PersonalDAboutMeCell.contentTextV.text forKey:@"description"];
            _tableViewDateSoure[indexPath.section][indexPath.row][@"content"] = PersonalDAboutMeCell.contentTextV.text;
        }];
    }
    
    if ([cell isKindOfClass:[NakedLocationCell class]]) {
        
         ((NakedLocationCell*)cell).localTitleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        ((NakedLocationCell*)cell).LocationNameLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
    }
    
    if ([cell isKindOfClass:[NakedBirthdayCell class]]) {
        
        ((NakedBirthdayCell*)cell).birthdayTitleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        ((NakedBirthdayCell*)cell).dateLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
    }
    
    if ([cell isKindOfClass:[NakedGenderCell class]]) {
        
        ((NakedGenderCell*)cell).genderTitleLabel.text = _tableViewDateSoure[indexPath.section][indexPath.row][@"title"];
        ((NakedGenderCell*)cell).gender = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
        
        [((NakedGenderCell*)cell) setSelectedGender:^(NSString *gender) {
            // 变换性别
            [self.atter setObject:gender forKey:@"gender"];
            _tableViewDateSoure[indexPath.section][indexPath.row][@"content"] = gender;
            
        }];
    }
    return cell;
}
- (NSDate*)stringToDate
{
    NSString* string = @"19600101";
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    return inputDate;
//    NSLog(@"date = %@", inputDate);
}
- (void)showSelectDatePickerView
{
    @weakify(self)
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    RMAction *selectAction = [RMAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Submit"] style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        @strongify(self)
        NSString*  dateString = [Utility getYYYYMMDD:((UIDatePicker *)controller.contentView).date];
        [self.atter setObject:dateString forKey:@"birthday"];
        ((NakedBirthdayCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]]).dateLabel.text = dateString;
        _tableViewDateSoure[2][1][@"content"] = dateString;
        NSLog(@"Successfully selected date: %@", dateString);
    }];
    RMAction *cancelAction = [RMAction actionWithTitle:[GDLocalizableClass getStringForKey:@"Cancel"] style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
//    dateSelectionController.title = [GDLocalizableClass getStringForKey:@"Please select a date"] ;
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.date = [NSDate date];
    dateSelectionController.datePicker.maximumDate = [NSDate date];
    dateSelectionController.datePicker.minimumDate = [self stringToDate];
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_identifiers[indexPath.section][indexPath.row] isEqualToString:@"lineCell"]) {
        return 30;
    }
    
    switch (indexPath.section) {
        case 1:
        {
            return 160;
        }
            break;
        case 3:
        case 4:
        {
            NSString *content = _tableViewDateSoure[indexPath.section][indexPath.row][@"content"];
            _cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPerSonalTagListCell"];
            if (content.length>0) {
                _cell.dataList = [content componentsSeparatedByString:@","];
            }
            return _cell.collectionView.contentSize.height+65;
        }
            break;
        default:
            return 54;
            break;
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==2) {
                //公司
                
            }
        }
            break;
        case 2:
        {
            if (indexPath.row==0) {
                //地区
                
            }
            
            if (indexPath.row==1) {
                //生日
                [mixPanel track:@"User_edit_birthday" properties:logInDic];
                [self showSelectDatePickerView];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"selectHub"]) {
        [mixPanel track:@"User_edit_location" properties:logInDic];
        @weakify(self)
        ((NakedHubSelectViewController*)[segue destinationViewController]).selectModel = _userModel.hub;
        ((NakedHubSelectViewController*)[segue destinationViewController]).isBook = YES;
        [((NakedHubSelectViewController*)[segue destinationViewController]) setSelectHubCallBack:^(NakedHubModel *hubModel) {
            @strongify(self)
            ((NakedLocationCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]).LocationNameLabel.text = hubModel.name;
            _tableViewDateSoure[2][0][@"content"] = hubModel.name;
            [self.atter setObject:@(hubModel.hubId) forKey:@"hubId"];
        }];
    }
}

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
        _userPortraitView.image = [Utility imageByScalingToMaxSize:portraitImg];
        _HeadPortraitImage = [Utility imageByScalingToMaxSize:portraitImg];
    }
    else
    {
        _backGroupImageView.image = [Utility imageByScalingToMaxSize:portraitImg];
        _backGroupImage = [Utility imageByScalingToMaxSize:portraitImg];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)subMit:(id)sender {
    
    [mixPanel track:@"User_edit_save" properties:logInDic];

   NSMutableArray *images = [NSMutableArray array];
    if (_HeadPortraitImage) {
        [images addObject:@{@"key":@"portaitFile",@"image":_HeadPortraitImage}];
    }
    if (_backGroupImage) {
        [images addObject:@{@"key":@"backgroundFile",@"image":_backGroupImage}];
    }
    
    //判断用户名是否为空
    NSString *name_space_str = [self.atter[@"nickname"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([name_space_str isEqualToString:@""]||name_space_str.length==0||name_space_str==nil){
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Please enter your full name."]];
    }else{
        [HttpRequest upLoadWithUrl:user_profile_edit andViewContoller:self andHudMsg:@"" andUploadImageName:@"file" andImages:images andAttributes:self.atter andBlock:^(id response, NSError *error) {
            if (!error) {
                NakedUserModel *model = [MTLJSONAdapter modelOfClass:[NakedUserModel class] fromJSONDictionary:response[@"result"] error:nil];
                [[NSUserDefaults standardUserDefaults]setObject:model.nickname?model.nickname:@"" forKey:kUserName];
                [[NSUserDefaults standardUserDefaults]setObject:model.portait?model.portait:@"" forKey:kUserAvatarUrl];
                if (model.hub) {
                    [[NSUserDefaults standardUserDefaults]setObject:@(model.hub.hubId) forKey:@"hubID"];
                    [[NSUserDefaults standardUserDefaults]setObject:model.hub.address forKey:@"hubaddress"];
                    [[NSUserDefaults standardUserDefaults]setObject:model.hub.name forKey:@"hubname"];
                    [[NSUserDefaults standardUserDefaults]setObject:model.hub.picture forKey:@"hubpicture"];
                }
                if (model.company) {
                    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"isCompany"];
                }
                [[NSUserDefaults standardUserDefaults]synchronize];
                if (_isSign) {
                    [self showHudInView:self.view hint:@""];
                    [Utility loginResultAndBlock:^(id response, EMError *error) {
                        [self hideHud];
                        if (!error) {
                            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                            UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
                            [[UIApplication sharedApplication].delegate window].rootViewController = tabBarVC;
                        }
                        else
                        {
                            [Utility showErrorWithVC:self andMessage:error.description];
                        }
                    }];
                }
                
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


- (IBAction)editPortrait:(UIButton *)sender {
    [mixPanel track:@"User_edit_portrait" properties:logInDic];
    [[self.tableView TPKeyboardAvoiding_findFirstResponderBeneathView:self.tableView] resignFirstResponder];
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"]destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
    actionsheet.tag = 1000;
    [actionsheet showInView:self.view];
}

- (IBAction)editBackGroupView:(UITapGestureRecognizer *)sender {
    [mixPanel track:@"User_edit_background" properties:logInDic];
    [[self.tableView TPKeyboardAvoiding_findFirstResponderBeneathView:self.tableView] resignFirstResponder];
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[GDLocalizableClass getStringForKey:@"Cancel"]destructiveButtonTitle:nil otherButtonTitles:[GDLocalizableClass getStringForKey:@"Take Photo"],[GDLocalizableClass getStringForKey:@"Choose From Album"], nil];
    actionsheet.tag = 1001;
    [actionsheet showInView:self.view];
}
@end

/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "GroupSubjectChangingViewController.h"

#import "HttpRequest.h"



@interface GroupSubjectChangingViewController () <UITextFieldDelegate>
{
    EMGroup         *_group;
    BOOL            _isOwner;
    UITextField     *_subjectField;
}

@end

@implementation GroupSubjectChangingViewController

- (instancetype)initWithGroup:(EMGroup *)group  andIsOwenr:(BOOL)isOwner
{
    self = [self init];
    if (self) {
        _group = group;
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        _isOwner = isOwner;
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _isOwner?NSLocalizedString(@"title.groupSubjectChanging", @"Change group name"):@"查看群名称";


    if (_isOwner)
    {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        saveItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:saveItem];
    }

    CGRect frame = CGRectMake(20, 80, self.view.frame.size.width - 40, 40);
    _subjectField = [[UITextField alloc] initWithFrame:frame];
    _subjectField.layer.cornerRadius = 5.0;
    _subjectField.layer.borderWidth = 1.0;
    _subjectField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _subjectField.placeholder = NSLocalizedString(@"group.setting.subject", @"Please input group name");
    _subjectField.text = _group.groupSubject;
    if (!_isOwner)
    {
        _subjectField.enabled = NO;
    }
    frame.origin = CGPointMake(frame.size.width - 5.0, 0.0);
    frame.size = CGSizeMake(5.0, 40.0);
    UIView *holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.rightView = holder;
    _subjectField.rightViewMode = UITextFieldViewModeAlways;
    frame.origin = CGPointMake(0.0, 0.0);
    holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.leftView = holder;
    _subjectField.leftViewMode = UITextFieldViewModeAlways;
    _subjectField.delegate = self;
    [self.view addSubview:_subjectField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)back
{
    if ([_subjectField isFirstResponder])
    {
        [_subjectField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
}

- (void)saveSubject
{
    if (_subjectField.text.length<=0) {
        [self showHint:@"请输入群名称"];
        return;
    }
    
//    [HttpRequest postWithURLSession:API_IM_CHATGROUP_EDIT andViewContoller:self andHudMsg:@"修改中..." andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"huanxinGroupId":_group.groupId,@"groupName":_subjectField.text}] andBlock:^(id response, NSError *error) {
//        [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_subjectField.text forGroup:_group.groupId];
//        [self back];
//    }];
    
    
}

@end

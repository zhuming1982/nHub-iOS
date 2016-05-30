//
//  NakedRegisterFirstViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedRegisterFirstViewController.h"
#import "Constant.h"
#import "UIViewController+KeyboardAnimation.h"
#import "Utility.h"
#import "UIViewController+DismissKeyboard.h"
#import "TECustomTextField.h"
#import "HttpRequest.h"
#import "NakedRegisterSecondViewController.h"
#import "CountryCodeTableViewController.h"


@interface NakedRegisterFirstViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MobileNumberLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passWordLeftConstraint;

@property (weak, nonatomic) IBOutlet TECustomTextField *NameTextF;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet TECustomTextField *passWordTextF;
@property (weak, nonatomic) IBOutlet TECustomTextField *phoneNumberTextF;

@end

@implementation NakedRegisterFirstViewController
@synthesize country_code_str,Country_btn;


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isTeamCodeLogin) {
        self.title = [GDLocalizableClass getStringForKey:@"Login"];
    }
    else
    {
        self.title = [GDLocalizableClass getStringForKey:@"Join Now"];
    }
    [self.NameTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Full Name"]];
    [self.phoneNumberTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Mobile Number"]];
    [self.passWordTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Password"]];
    
     [self.bottomBtn setTitle:[GDLocalizableClass getStringForKey:@"GET CODE VIA SMS"] forState:UIControlStateNormal];
    
    
    [self setupForDismissKeyboard];
    
    if (country_code_str==nil) {
        country_code_str=@"+86";
        [self.Country_btn setTitle:[NSString stringWithFormat:@"+86"] forState:UIControlStateNormal];
    }
    
    if ([Utility isiPhone4]) {
        _NameTextF.font = [UIFont fontWithName:@"Avenir-Book" size:18];
        _passWordTextF.font = [UIFont fontWithName:@"Avenir-Book" size:18];
        _phoneNumberTextF.font = [UIFont fontWithName:@"Avenir-Book" size:18];
    }
    [_NameTextF becomeFirstResponder];
    
    @weakify(self)
    
    [[RACSignal combineLatest:@[[RACSignal merge:@[[_NameTextF rac_textSignal], RACObserve(_NameTextF, text)]],[RACSignal merge:@[[_passWordTextF rac_textSignal], RACObserve(_passWordTextF, text)]],[RACSignal merge:@[[_phoneNumberTextF rac_textSignal], RACObserve(_phoneNumberTextF, text)]]] reduce:^(NSString *name, NSString *passWord, NSString *phoneNumber){
        @strongify(self)
        if (name.length>20) {
            self.NameTextF.text = [name  substringToIndex:20];
        }
        if (passWord.length>20) {
            self.passWordTextF.text = [passWord  substringToIndex:20];
        }
        if (phoneNumber.length>20) {
            self.phoneNumberTextF.text = [phoneNumber  substringToIndex:20];
        }
        return @(name.length>0 && passWord.length>0 && phoneNumber.length>0);
    }]subscribeNext:^(id x) {
        @strongify(self)
        [self.bottomBtn setBackgroundColor:[x boolValue]?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
        self.bottomBtn.enabled = [x boolValue];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bottomBtn.frame = CGRectMake(0, kScreenHeight-54, kScreenWidth, 54);
    [[[UIApplication sharedApplication].delegate window] addSubview:self.bottomBtn];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
    [_NameTextF resignFirstResponder];
    [_passWordTextF resignFirstResponder];
    [_phoneNumberTextF resignFirstResponder];
    self.bottomBtn.transform = CGAffineTransformMakeTranslation(0, 0);
    self.tableView.transform = CGAffineTransformMakeTranslation(0,0);
    [self.bottomBtn removeFromSuperview];
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            CGFloat transformY;
            if ([Utility isiPhone4]) {
                transformY = -CGRectGetHeight(keyboardRect)+182;
            }
            else if ([Utility isiPhone5]) {
                transformY = -CGRectGetHeight(keyboardRect)+205;
            }
            else if ([Utility isiPhone6]) {
                transformY = 0;
            }
            else if ([Utility isiPhone6p]) {
                transformY = 0;
            }
            self.tableView.transform = CGAffineTransformMakeTranslation(0,transformY);
            self.bottomBtn.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(keyboardRect));
        } else {
            self.bottomBtn.transform = CGAffineTransformMakeTranslation(0, 0);
//            self.tableView.transform = CGAffineTransformMakeTranslation(0,0);
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        if ([Utility isiPhone4]||[Utility isiPhone5]) {
            return 90;
        }
        return 128;
    }
    else
    {
        if ([Utility isiPhone4]||[Utility isiPhone5]) {
            return 44;
        }
        return 64;
    }
    
    
}

//＋86
- (IBAction)Country_code_act:(UIButton *)sender {
    [mixPanel track:@"Regist_countryCode" properties:logOutDic];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"CountryCode" bundle:[NSBundle mainBundle]];
    CountryCodeTableViewController *CountryCode_VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"CountryCode"];
    
    @weakify(self)
    [CountryCode_VC setCountry_Back:^(NSString *BacK) {
        @strongify(self)
        self.country_code_str=BacK;
        [self.Country_btn setTitle:[NSString stringWithFormat:@"+%@",BacK] forState:UIControlStateNormal];
    }];
    
    [self.navigationController pushViewController:CountryCode_VC animated:YES];

}

- (IBAction)getSmsCode:(id)sender {
    [self getSmsCode];
}

- (void) getSmsCode
{
    [mixPanel track:@"Regist_getCode" properties:logOutDic];
    [HttpRequest postWithURLSession:auth_reqSmsCode
                   andViewContoller:self
                          andHudMsg:@""
                      andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"mobile":_phoneNumberTextF.text,@"phoneCode":country_code_str,@"verifyType":@"REG"}]
                           andBlock:^(id response, NSError *error) {
                               if (!error) {
                                   [self.attr addEntriesFromDictionary:@{@"nickname":_NameTextF.text,@"mobile":_phoneNumberTextF.text,@"password":_passWordTextF.text}];
                                   NSLog(@"%@",response);
                                   [_NameTextF resignFirstResponder];
                                   [_passWordTextF resignFirstResponder];
                                   [_phoneNumberTextF resignFirstResponder];
                                NakedRegisterSecondViewController*RegisterSecondVC = ((NakedRegisterSecondViewController*)[Utility pushViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedRegisterSecondViewController" andParent:self]);
                                   RegisterSecondVC.attr = self.attr;
                                   RegisterSecondVC.isLogin = _isTeamCodeLogin?teamLogin:signUp;
                               }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}


@end

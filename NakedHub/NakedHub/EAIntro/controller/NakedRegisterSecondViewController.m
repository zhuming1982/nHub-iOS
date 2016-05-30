//
//  NakedRegisterSecondViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedRegisterSecondViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "Utility.h"
#import "UIViewController+DismissKeyboard.h"
#import "TECustomTextField.h"
#import "NakedPaymentListViewController.h"
#import "HttpRequest.h"
#import "NakedUserModel.h"
#import "NakedEditPerSonalDetailsViewController.h"



@interface NakedRegisterSecondViewController ()
{
    NSTimer *timer;
    NSInteger seconds;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstraint;

@property (weak, nonatomic) IBOutlet UIButton *reSendBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet TECustomTextField *SmsCodeTextF;
- (IBAction)resendCode:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *enter4CodeLabel;
@end

@implementation NakedRegisterSecondViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField.text stringByAppendingString:string].length>20) {
//        textField.text =  [[textField.text stringByAppendingString:string] substringToIndex:20];
//        return NO;
//    }
//    
//    if (range.location>20) {
//        return [string isEqualToString:@""];
//    }
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [timer invalidate];
    seconds = 45;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ActionCountDown:) userInfo:nil repeats:YES];
    [timer fire];
    [self setupForDismissKeyboard];
    [_SmsCodeTextF becomeFirstResponder];
    [self.nextBtn setTitle:[GDLocalizableClass getStringForKey:@"NEXT"] forState:UIControlStateNormal];
    switch (_isLogin) {
        case login:
        {
            self.navigationItem.title = [GDLocalizableClass getStringForKey:@"Login"];
            [self.nextBtn setTitle:[GDLocalizableClass getStringForKey:@"NEXT"] forState:UIControlStateNormal];
        }
            break;
        case teamLogin:
        {
            self.navigationItem.title = [GDLocalizableClass getStringForKey:@"Login"];
            [self.nextBtn setTitle:[GDLocalizableClass getStringForKey:@"MAKE MY PROFILE"] forState:UIControlStateNormal];
        }
            break;
        case signUp:
        {
            self.navigationItem.title = [GDLocalizableClass getStringForKey:@"Join Now"];
        }
            break;
        default:
            break;
    }
    
    
    
    [self.SmsCodeTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"enter code"]];
    [self.enter4CodeLabel setText:[GDLocalizableClass getStringForKey:@"Now enter the 4-digit code you received via SMS."]];
   
    
    
    @weakify(self)
    [[RACSignal merge:@[_SmsCodeTextF.rac_textSignal,RACObserve(self.SmsCodeTextF, text)]] subscribeNext:^(NSString *code) {
        @strongify(self)
        if (code.length>10) {
            self.SmsCodeTextF.text = [code substringToIndex:10];
        }
        [self.nextBtn setBackgroundColor:code.length>0?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
        self.nextBtn.enabled = code.length>0;
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
    [timer invalidate];
    [_reSendBtn setTitle:[GDLocalizableClass getStringForKey:@"Resend code?"] forState:UIControlStateNormal];
    _reSendBtn.enabled = YES;
    seconds = 45;
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            CGFloat transformY;
            if ([Utility isiPhone4]) {
                transformY = -60;
            }
            else if ([Utility isiPhone5]) {
                transformY = -50;
            }
            else if ([Utility isiPhone6]) {
                transformY = 50;
            }
            else if ([Utility isiPhone6p]) {
                transformY = 80;
            }
            self.topContstraint.constant = transformY;
            self.bottomBtnConstraint.constant = CGRectGetHeight(keyboardRect);
        } else {
            self.bottomBtnConstraint.constant = 0.0f;
            self.topContstraint.constant = 80.f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}




- (IBAction)next:(UIButton *)sender {
    
    [mixPanel track:@"SMS_Next" properties:logOutDic];
    if (_isLogin == login||_isLogin == teamLogin) {
        if (_isLogin==teamLogin) {
            NSString *u = self.attr[@"mobile"];
            NSString *p = self.attr[@"password"];
            [self.attr setObject:u forKey:@"u"];
            [self.attr setObject:p forKey:@"p"];
//            [self.attr removeObjectForKey:@"mobile"];
//            [self.attr removeObjectForKey:@"password"];
        }
        [self.attr setObject:_SmsCodeTextF.text forKey:@"verifyCode"];
        [HttpRequest postWithURLSession:auth_login andViewContoller:self andHudMsg:@"" andAttributes:self.attr andBlock:^(id response, NSError *error) {
            if (!error) {
                NakedUserModel *model = [MTLJSONAdapter modelOfClass:[NakedUserModel class] fromJSONDictionary:response[@"result"] error:nil];
                [[NSUserDefaults standardUserDefaults]setObject:@(model.userId) forKey:kUserIdName];
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
                if (_isLogin == teamLogin)
                {
                    NakedEditPerSonalDetailsViewController *EditPerSonalDetailsVC = (NakedEditPerSonalDetailsViewController *)[Utility pushViewControllerWithStoryboard:@"PersonalDetails" andViewController:@"NakedEditPerSonalDetailsViewController" andParent:self];
                    EditPerSonalDetailsVC.userModel = model;
                    EditPerSonalDetailsVC.isSign = YES;
                }
                else
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
            }
        }];
    }
    else
    {
        NSString *mobile = self.attr[@"mobile"];
        [HttpRequest postWithURLSession:auth_verify andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"verifyCode":_SmsCodeTextF.text,@"mobile":mobile,@"verifyType":@"REG"}] andBlock:^(id response, NSError *error) {
            if (!error) {
                if ([response[@"result"]boolValue]) {
                    NakedPaymentListViewController *PaymentListVC = (NakedPaymentListViewController*)[Utility pushViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedPaymentListViewController" andParent:self];
                    PaymentListVC.attr = self.attr;
                }
                else
                {
                    [Utility  showErrorWithVC:self andMessage:response[@"msg"]?response[@"msg"]:[GDLocalizableClass getStringForKey:@"Code Message"]];
                }
            }
        }];
    }
}
-(void) ActionCountDown:(NSTimer*)time
{
    if (seconds!=0) {
        
        [_reSendBtn setTitle:[NSString stringWithFormat:[GDLocalizableClass getStringForKey:@"%li seconds"],(long)seconds] forState:UIControlStateNormal];
        _reSendBtn.enabled = NO;
        seconds--;
    }
    else
    {
        [timer invalidate];
        [_reSendBtn setTitle:[GDLocalizableClass getStringForKey:@"Resend code?"]  forState:UIControlStateNormal];
        _reSendBtn.enabled = YES;
        seconds = 45;
    }
}

- (IBAction)resendCode:(UIButton *)sender {
    [mixPanel track:@"SMS_Resend" properties:logOutDic];
    NSMutableDictionary *attr = nil;
    if (_isLogin==login) {
        attr = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":self.attr[@"u"],@"phoneCode":@"+86",@"verifyType":@"LOGIN"}];
    }
    else
    {
        attr = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":self.attr[@"mobile"],@"phoneCode":@"+86",@"verifyType":@"REG"}];
    }
    [HttpRequest postWithURLSession:auth_reqSmsCode
                   andViewContoller:self
                          andHudMsg:@""
                      andAttributes:attr
                           andBlock:^(id response, NSError *error) {
                               if (!error) {
                                   NSLog(@"%@",response);
//                                   _SmsCodeTextF.text = response[@"result"];
                                   [timer invalidate];
                                   seconds = 45;
                                   timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ActionCountDown:) userInfo:nil repeats:YES];
                                   [timer fire];
                               }
                           }];
}

@end

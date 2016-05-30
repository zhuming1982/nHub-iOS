//
//  NakedLoginWithEmailViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedLoginWithEmailViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "Utility.h"
#import "UIViewController+DismissKeyboard.h"
#import "TECustomTextField.h"
#import "HttpRequest.h"

@interface NakedLoginWithEmailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet TECustomTextField *emailTextF;
@property (weak, nonatomic) IBOutlet TECustomTextField *passWordTextF;

@property (weak, nonatomic) IBOutlet UIButton *login_btn;

@end

@implementation NakedLoginWithEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    
    [self.emailTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Email"]];
    [self.passWordTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"Password"]];
    [self.login_btn setTitle:[GDLocalizableClass getStringForKey:@"LOGIN"] forState:UIControlStateNormal];
    
    @weakify(self)
    [[RACSignal combineLatest:@[[RACSignal merge:@[[_emailTextF rac_textSignal], RACObserve(_emailTextF, text)]],[RACSignal merge:@[[_passWordTextF rac_textSignal], RACObserve(_passWordTextF, text)]]] reduce:^(NSString *email, NSString *passWord){
        @strongify(self)
        if (email.length>50) {
            self.emailTextF.text =  [email substringToIndex:50];
        }
        if (passWord.length>20) {
            self.passWordTextF.text =  [passWord substringToIndex:20];
        }
        return @(self.emailTextF.text.length>0 && self.passWordTextF.text.length>0);
    }]subscribeNext:^(id x) {
        @strongify(self)
        [self.login_btn setBackgroundColor:[x boolValue]?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
        self.login_btn.enabled = [x boolValue];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.emailTextF resignFirstResponder];
    [self.passWordTextF resignFirstResponder];
    [self an_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.bottomBtnConstraint.constant = CGRectGetHeight(keyboardRect);
            if ([Utility isiPhone4]) {
                _topConstraint.constant = 50;
            }
        } else {
            self.bottomBtnConstraint.constant = 0.0f;
            _topConstraint.constant = 114;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Login:(UIButton *)sender {
    [self login];
}

-(void)login{
    
    [mixPanel track:@"Login_Email_login" properties:logOutDic];
    
    [HttpRequest postWithURLSession:auth_login
                   andViewContoller:self
                          andHudMsg:@""
                      andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"u":_emailTextF.text,@"p":_passWordTextF.text}]
                           andBlock:^(id response, NSError *error) {
                               if (!error) {
                                   [self.attr addEntriesFromDictionary:@{@"u":_emailTextF.text,@"p":_passWordTextF.text}];
                                   
                                   if ([response[@"code"]integerValue]==200)
                                   {
                                       if(response[@"result"]!=nil){
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
                                       }else{
                                           NSLog(@"登入失败");
                                       }
                                   }
                                   else
                                   {
                                       if (_showError) {
                                           _showError(response[@"msg"]);
                                       }
                                   }
                                   
                               }
                           }];
    
}
@end

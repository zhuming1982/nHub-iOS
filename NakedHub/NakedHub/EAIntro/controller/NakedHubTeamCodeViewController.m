//
//  NakedHubTeamCodeViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubTeamCodeViewController.h"
#import "TECustomTextField.h"
#import "UIViewController+KeyboardAnimation.h"
#import "Utility.h"
#import "UIViewController+DismissKeyboard.h"
#import "NakedRegisterFirstViewController.h"
#import "NakedHubBenifitViewController.h"

@interface NakedHubTeamCodeViewController ()

@property (weak, nonatomic) IBOutlet TECustomTextField *codeTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UILabel *teamCodeRegist;
@property (weak, nonatomic) IBOutlet UIButton *whatBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NakedHubTeamCodeViewController

- (IBAction)loginAction:(UIButton *)sender {
    
    [mixPanel track:@"Login_teamCode_login" properties:logOutDic];
    [HttpRequest postWithURLSession:auth_teamCode_check andViewContoller:self andHudMsg:@"" andAttributes:[@{@"teamCode":_codeTextF.text}mutableCopy] andBlock:^(id response, NSError *error) {
        if (!error) {
            if (self.loginCallBack) {
                self.loginCallBack(response,_codeTextF.text);
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    [self.teamCodeRegist setText:[GDLocalizableClass getStringForKey:@"Please enter the activation code you received when you purchased your membership."]];
    
    [self.codeTextF setPlaceholder:[GDLocalizableClass getStringForKey:@"8-Digit Code"]];
    
    [self.whatBtn setTitle:[GDLocalizableClass getStringForKey:@"What’s this?"] forState:UIControlStateNormal];
    
    [self.loginBtn setTitle:[GDLocalizableClass getStringForKey:@"NEXT"] forState:UIControlStateNormal];
    
    @weakify(self)
    [[RACSignal merge:@[_codeTextF.rac_textSignal,RACObserve(_codeTextF, text)]]subscribeNext:^(NSString *text) {
       @strongify(self)
        if (text.length>20) {
            self.codeTextF.text =  [text substringToIndex:20];
        }
        [self.loginBtn setBackgroundColor:self.codeTextF.text.length>0?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
        self.loginBtn.enabled = self.codeTextF.text.length>0;
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_codeTextF resignFirstResponder];
    [self an_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.bottomBtnConstraint.constant = CGRectGetHeight(keyboardRect);
            if ([Utility isiPhone4]||[Utility isiPhone5]) {
                _topConstraint.constant = 0;
                _teamCodeRegist.alpha = 0.0;
            }
        } else {
            _teamCodeRegist.alpha = 1.0;
            self.bottomBtnConstraint.constant = 0.0f;
            _topConstraint.constant = 100;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)whatBtnAction:(id)sender {
    
    // what's this
    if (_whatsThis) {
        _whatsThis();
    }
}



@end

//
//  NakedLoginWithPhoneViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/18.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedLoginWithPhoneViewController.h"
#import "TECustomTextField.h"
#import "NakedRegisterSecondViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "Utility.h"
#import "UIViewController+DismissKeyboard.h"
#import "NakedMobileNumberCell.h"
#import "HttpRequest.h"
#import "CountryCodeTableViewController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface NakedLoginWithPhoneViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@end

@implementation NakedLoginWithPhoneViewController
@synthesize country_str,numberCell;


- (IBAction)getCodeSms:(UIButton *)sender {
    
    [mixPanel track:@"Login_Phone_getCode" properties:logOutDic];
    
    if (country_str==nil) {
        country_str=@"+86";
        [self.numberCell.CountryCode_btn setTitle:[NSString stringWithFormat:@"+86"] forState:UIControlStateNormal];
    }
    NSLog(@"country_str=%@",country_str);

    @weakify(self)
    [HttpRequest postWithURLSession:auth_reqSmsCode
                   andViewContoller:self
                          andHudMsg:@""
                      andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"mobile":self.numberCell.mobileNumberTextF.text,@"phoneCode":country_str,@"verifyType":@"LOGIN"}]
                           andBlock:^(id response, NSError *error) {
                               @strongify(self)
                               if (!error) {
                                   NSLog(@"%@",response);
                                   
                        if (self.getCodeViaSms) {
                            [self.numberCell.mobileNumberTextF resignFirstResponder];
                            self.getCodeViaSms(self.numberCell.mobileNumberTextF.text,response);
                                   }
                               }
                           }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    
    [self.bottomBtn setTitle:[GDLocalizableClass getStringForKey:@"GET CODE VIA SMS"] forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.numberCell.mobileNumberTextF resignFirstResponder];
    [self an_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard {
    
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.bottomBtnConstraint.constant = CGRectGetHeight(keyboardRect);
        } else {
            self.bottomBtnConstraint.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0 ?@"topCell":@"MobileNumberCell" forIndexPath:indexPath];
    if (!self.numberCell&&indexPath.row==1) {
        self.numberCell = (NakedMobileNumberCell*)cell;
        @weakify(self)
        
        [[RACSignal merge:@[[self.numberCell.mobileNumberTextF rac_textSignal], RACObserve(self.numberCell.mobileNumberTextF, text)]] subscribeNext:^(NSString *text) {
            @strongify(self)
            [self.bottomBtn setBackgroundColor:text.length>0?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
            self.bottomBtn.enabled = text.length>0;
            if (text.length>20) {
                self.numberCell.mobileNumberTextF.text =  [text substringToIndex:20];
            }
        }];
    }
    [self.numberCell.CountryCode_btn addTarget:self action:@selector(CountryCode) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0?([Utility isiPhone4]?85:128):([Utility isiPhone4]?44:64);
}

//国家码
-(void)CountryCode{
    
    [mixPanel track:@"Login_Phone_countryCode" properties:logOutDic];
    
    if (self.getCountryCode) {
        self.getCountryCode(self.numberCell.CountryCode_btn.titleLabel.text);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

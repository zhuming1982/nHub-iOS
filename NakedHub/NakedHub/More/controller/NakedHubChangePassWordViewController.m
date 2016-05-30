//
//  NakedHubChangePassWordViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubChangePassWordViewController.h"

@interface NakedHubChangePassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentPTF;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *confirmPTF;

@end

@implementation NakedHubChangePassWordViewController
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changePasswordAction:(UIBarButtonItem *)sender {

    [mixPanel track:@"changePassword_Done" properties:logInDic];
    if (![self.PasswordTF.text isEqualToString:self.confirmPTF.text]) {
        [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"passwords do not match"]];
        return;
    }
    [HttpRequest postWithURLSession:auth_password_modify andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"currentPass":_currentPTF.text,@"newPass":_PasswordTF.text}] andBlock:^(id response, NSError *error) {
        if (!error) {
            if ([response[@"result"] boolValue]) {
                [Utility showSuccessWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"Your password has been changed."]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"Change Password"];
    [self.currentPTF setPlaceholder:[GDLocalizableClass getStringForKey:@"Current Password"]];
    [self.confirmPTF setPlaceholder:[GDLocalizableClass getStringForKey:@"Re-type Password"]];
    [self.PasswordTF setPlaceholder:[GDLocalizableClass getStringForKey:@"New Password"]];
    
    @weakify(self)
    [[RACSignal combineLatest:@[[RACSignal merge:@[[_currentPTF rac_textSignal], RACObserve(_currentPTF, text)]], [RACSignal merge:@[[_PasswordTF rac_textSignal], RACObserve(_PasswordTF, text)]], [RACSignal merge:@[[_confirmPTF rac_textSignal], RACObserve(_confirmPTF, text)]]] reduce:^(NSString *currentP,NSString *newP,NSString *confirmP){
        @strongify(self)
        if (currentP.length>10) {
            self.currentPTF.text = [currentP substringToIndex:10];
        }
        if (newP.length>10) {
            self.PasswordTF.text = [newP substringToIndex:10];
        }
        if (confirmP.length>10) {
            self.confirmPTF.text = [confirmP substringToIndex:10];
        }
        return @((self.currentPTF.text.length>0 && self.PasswordTF.text.length>0 && self.confirmPTF.text.length>0));
    }]subscribeNext:^(id x) {
        @strongify(self)
        self.navigationItem.rightBarButtonItem.enabled = [x boolValue];
    }];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

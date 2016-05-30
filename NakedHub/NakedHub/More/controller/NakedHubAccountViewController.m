//
//  NakedHubAccountViewController.m
//  NakedHub
//
//  Created by zhuming on 16/4/14.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubAccountViewController.h"

@interface NakedHubAccountViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hubLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePwdLabel;


@end

@implementation NakedHubAccountViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"Account"];
    [self.changePwdLabel setText:[GDLocalizableClass getStringForKey:@"CHANGE  PASSWORD"]];
    
    @weakify(self)
    [HttpRequest getWithUrl:user_detail andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            NSError *error1 = nil;
            NakedUserModel *userDetails = [MTLJSONAdapter modelOfClass:[NakedUserModel class] fromJSONDictionary:response[@"result"] error:&error1];
            if (error1) {
                NSLog(@"%@",error1);
            }
            [self.userIconView sd_setImageWithURL:[NSURL URLWithString:userDetails.portait] placeholderImage:[UIImage imageNamed:@"userIcon"]];
            self.userNameLabel.text = userDetails.nickname;
            NSString *tempHubName;
            if (userDetails.company.name) {
                tempHubName = userDetails.company.name;
            }
            if (userDetails.hub.name) {
                tempHubName = [tempHubName stringByAppendingString:[NSString stringWithFormat:@"，%@",userDetails.hub.name]];
            }
            self.hubLabel.text = tempHubName;
        }
    }];
}

-(void)viewDidLayoutSubviews
{
    [Utility configSubView:self.userIconView CornerWithRadius:self.userIconView.frame.size.width/2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [mixPanel track:@"Account_ChangePassword" properties:logInDic];
}

@end

//
//  NakedHubAboutDetailTableViewController.m
//  NakedHub
//
//  Created by nanqian on 16/4/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubAboutDetailTableViewController.h"
#import "AboutDetailTableViewCell.h"
#import "NakedHubBenifitViewController.h"

@interface NakedHubAboutDetailTableViewController ()

@property (nonatomic ,strong) NSMutableArray     *titleArray;

@end

@implementation NakedHubAboutDetailTableViewController

@synthesize titleArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"About"];
    
    titleArray = [NSMutableArray arrayWithCapacity:0];
    [titleArray addObject:@"Terms of Service"];
    [titleArray addObject:@"Community Guidelines"];
//    [titleArray addObject:@"Version"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     AboutDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutDetailTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.titleCell setText:[GDLocalizableClass getStringForKey:titleArray[indexPath.row]]];
        
    }
    
   
    if (indexPath.section == 1) {
       
        if (indexPath.row == 0) {

            [cell.titleCell setText:[GDLocalizableClass getStringForKey:@"Version"]];
            [cell.contentLabel setText:versionNum];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }

    }
    
    return cell;
}



// Override to support conditional editing of the table view.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        
        NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
        
        if (indexPath.row == 0) {
            benifitVC.fromPageType = FromPayment;
            [mixPanel track:@"About_TermsOfService" properties:logInDic];
        }
        if (indexPath.row == 1) {
            benifitVC.fromPageType = FromCommunity;
            [mixPanel track:@"About_CommunityGuidelines" properties:logInDic];
        }
    }
}

- (IBAction)BackBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

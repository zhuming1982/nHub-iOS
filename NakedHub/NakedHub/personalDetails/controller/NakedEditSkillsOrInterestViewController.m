//
//  NakedEditSkillsOrInterestViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEditSkillsOrInterestViewController.h"

@interface NakedEditSkillsOrInterestViewController ()

@end

@implementation NakedEditSkillsOrInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    self.addTextF.placeholder=[GDLocalizableClass getStringForKey:@"Add"];
    @weakify(self)
    
    [[RACSignal merge:@[[_addTextF rac_textSignal], RACObserve(_addTextF, text)]] subscribeNext:^(NSString *text) {
        @strongify(self)
        if ([text isEqualToString:@" "]) {
            
            self.addTextF.text = @"";
        }
        if (text.length>50) {
            self.addTextF.text =  [text substringToIndex:50];
        }
        [self.addBtn setTitleColor:self.addTextF.text.length > 0?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:193.0/255.0 green:196.0/255.0 blue:199.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.addBtn.enabled = self.addTextF.text.length > 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ((UILabel*)[cell viewWithTag:100]).text = _dataList[indexPath.row];
    return cell;
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         if ([self.title isEqualToString:@"Edit Skills"]) {
             [mixPanel track:@"editSkills_delete" properties:logInDic];
         }
         if ([self.title isEqualToString:@"Edit Interest"]) {
             [mixPanel track:@"editInterests_delete" properties:logInDic];
         }
         if ([self.title isEqualToString:@"Edit Services"]) {
             [mixPanel track:@"editServices_delete" properties:logInDic];
         }
         
         [self.dataList removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         if (_editCallBack) {
             _editCallBack([Utility arrTostrWithArr:self.dataList]);
         }
         
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         
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


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAction:(UIButton *)sender {
    
    if ([self.title isEqualToString:@"Edit Skills"]) {
        [mixPanel track:@"editSkills_add" properties:logInDic];
    }
    if ([self.title isEqualToString:@"Edit Interest"]) {
        [mixPanel track:@"editInterests_add" properties:logInDic];
    }
    if ([self.title isEqualToString:@"Edit Services"]) {
        [mixPanel track:@"editServices_add" properties:logInDic];
    }
    
    [self.dataList insertObject:_addTextF.text atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    _addTextF.text = nil;
    if (_editCallBack) {
        _editCallBack([Utility arrTostrWithArr:self.dataList]);
    }
}
@end

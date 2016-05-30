//
//  NakedHubSelectViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubSelectViewController.h"
#import "NakedHubCell.h"

@interface NakedHubSelectViewController ()

@property (nonatomic,strong) NSArray<NakedHubModel*> *hubList;

@end

@implementation NakedHubSelectViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [GDLocalizableClass getStringForKey:@"Select Location"];
    
    
    
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    @weakify(self)
    [HttpRequest getWithUrl:hub_list andViewContoller:nil andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            self.hubList = [MTLJSONAdapter modelsOfClass:[NakedHubModel class] fromJSONArray:response[@"result"] error:nil];
            [self.tableView reloadData];
        }
        
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hubList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NakedHubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedHubCell" forIndexPath:indexPath];
    cell.hubModel = _hubList[indexPath.row];
    cell.checkBtn.hidden = !(_selectModel.hubId == _hubList[indexPath.row].hubId);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mixPanel track:@"selectLocation_listClick" properties:logInDic];
    if (_isBook) {
        if (self.selectHubCallBack) {
            [self.navigationController popViewControllerAnimated:YES];
            self.selectHubCallBack(_hubList[indexPath.row]);
        }
    }
    else
    {
        @weakify(self)
        [HttpRequest postWithURLSession:hub_bind andViewContoller:self andHudMsg:@"" andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"hubId":@(_hubList[indexPath.row].hubId)}] andBlock:^(id response, NSError *error) {
            if (!error) {
                @strongify(self)
                [[NSUserDefaults standardUserDefaults]setObject:@(_hubList[indexPath.row].hubId) forKey:@"hubID"];
                [[NSUserDefaults standardUserDefaults]setObject:_hubList[indexPath.row].address forKey:@"hubaddress"];
                [[NSUserDefaults standardUserDefaults]setObject:_hubList[indexPath.row].name forKey:@"hubname"];
                [[NSUserDefaults standardUserDefaults]setObject:_hubList[indexPath.row].picture forKey:@"hubpicture"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if (self.selectHubCallBack) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.selectHubCallBack(_hubList[indexPath.row]);
                }
            }
            else{
                [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
            }
            
        }];
    }
    
}

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

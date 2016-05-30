//
//  NakedEventsFilterViewController.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilterViewController.h"

#import "NakedEventsFilterHeaderView.h"
#import "NakedEventsFilterSegmentCell.h"
#import "NakedEventsFilterListCell.h"
#import "NakedEventsFilterListModel.h"
#import "NakedEventsFilter.h"

@interface NakedEventsFilterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (nonatomic, strong) NSArray<NakedEventsFilterListModel *> *filterArray;

@property (nonatomic, strong) NSArray *filterIdArray;
@property (nonatomic, strong) NSDictionary *filterDictionary;

@property (nonatomic, copy) NSString *region; 

@end

@implementation NakedEventsFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLabel.text = [GDLocalizableClass getStringForKey:@"Filter Events"];
    [_filterButton setTitle:[GDLocalizableClass getStringForKey:@"APPLY FILTERS"]forState:UIControlStateNormal];
    
    _filterDictionary = [[NakedEventsFilter shareInstance] getFilterDictionary];
    if (!(_filterDictionary == nil))
    {
        NSString *string = _filterDictionary[@"categoryId"];
        _filterIdArray  = [string componentsSeparatedByString:@","];
        _region = _filterDictionary[@"region"];
    } else {
        _region = @"MYHUB";
    }
    
    [HttpRequest getWithUrl:events_category andViewContoller:self andHudMsg:nil andAttributes:nil andBlock:^(id response, NSError *error)
     {
         if (!error)
         {
             _filterArray = [MTLJSONAdapter modelsOfClass:[NakedEventsFilterListModel class] fromJSONArray:response[@"result"] error:nil];
         }
         [_tableView reloadData];
     }];
//    _tableView.estimatedRowHeight = 100;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.allowsMultipleSelection = YES; // 设置 tableView 多选, 多选会保存数组
}

#pragma mark - Tableview

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    } else {
        NakedEventsFilterHeaderView *headerView = [[NakedEventsFilterHeaderView alloc] init];
        
        headerView.intersetsLabel.text = [GDLocalizableClass getStringForKey:@"What Interests You?"];
        [headerView.clearButton setTitle:[GDLocalizableClass getStringForKey:@"Clear"] forState:UIControlStateNormal];
        [headerView.clearButton addTarget:self action:@selector(headerClearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 70;
    } else {
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    } else {
        return _filterArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        NakedEventsFilterSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsFilterSegmentCell" forIndexPath:indexPath];
        
        if ([_region isEqualToString:@"MYHUB"]) {
            cell.segmentedControl.selectedSegmentIndex = 0;
        } else if ([_region isEqualToString:@"MYCITY"]) {
            cell.segmentedControl.selectedSegmentIndex = 1;
        } else {
            cell.segmentedControl.selectedSegmentIndex = 2;
        }
        
        [cell setSelectSegmentedControl:^(NSString *region) {
            _region = region;
        }];
        return cell;
    } else {
        NakedEventsFilterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakedEventsFilterListCell" forIndexPath:indexPath];
        
        cell.filterListModel = _filterArray[indexPath.row];
        if (_filterIdArray) {
            for (int i = 0; i < _filterIdArray.count; i++) {
                if ([_filterIdArray[i] integerValue] == _filterArray[indexPath.row].filterId)
                {
                    /* cell 的状态, 设置被选中状态 */
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mixPanel track:@"Filter_listClick" properties:logInDic];
}

#pragma mark - Filter Events
- (IBAction)filterEvents:(id)sender
{
    // 筛选按钮
    [mixPanel track:@"Filter_applyFilters" properties:logInDic];
    
    NSDictionary *filterDictionary;
    if (self.tableView.indexPathsForSelectedRows == nil) {
        filterDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_region, @"region", nil];
    } else {
        NSString *filterId;
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            if (filterId) {
                NSString *filterString = [NSString stringWithFormat:@",%ld", (long)_filterArray[indexPath.row].filterId];
                filterId = [filterId stringByAppendingString:filterString];
            } else {
                filterId = [NSString stringWithFormat:@"%ld", (long)_filterArray[indexPath.row].filterId];
            }
        }
        filterDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:filterId, @"categoryId", _region, @"region", nil];
    }    
    
    [[NakedEventsFilter shareInstance] initWithFilterDictionary:filterDictionary];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_filterEvents) {
            _filterEvents(filterDictionary);
        }
    }];
}

#pragma mark - HeaderClearButton
- (void)headerClearButtonClick:(UIButton *)sender
{
    /* 清空当前选择的 cell 刷新tableView */
    [mixPanel track:@"Filter_clear" properties:logInDic];
    _filterIdArray = nil;
    [_tableView reloadData];
}

- (IBAction)back:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:^{
       
   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

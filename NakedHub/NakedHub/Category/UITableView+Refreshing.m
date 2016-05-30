//
//  UITableView+Refreshing.m
//  NakedHub
//
//  Created by 朱明 on 16/3/10.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "UITableView+Refreshing.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation UITableView (Refreshing)

-(void)setRefreshing:(void (^)(bool isPull))block;
{
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block(YES);
        }
    }];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block(NO);
        }
    }];
    self.footer.hidden = YES;
}

-(void)endTableViewRefreshing:(BOOL)isPull andisHiddenFooter:(BOOL)Hidden
{
    [self reloadData];
    if (isPull) {
        self.footer.hidden = NO;
        [self.header endRefreshing];
    }
    else{
        [self.footer endRefreshing];
    }
    self.footer.hidden = Hidden;
}


@end

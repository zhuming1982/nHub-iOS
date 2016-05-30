//
//  UITableView+Refreshing.h
//  NakedHub
//
//  Created by 朱明 on 16/3/10.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UITableView (Refreshing)


-(void)setRefreshing:(void (^)(bool isPull))block;

-(void)endTableViewRefreshing:(BOOL)isPull andisHiddenFooter:(BOOL)Hidden;


@end

//
//  NakedTagListCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"

@interface NakedTagListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rtitleLabel;
- (IBAction)separate:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet SKTagView *tagView;


@end

//
//  tagListCCell.m
//  NakedHub
//
//  Created by zhuming on 16/3/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "tagListCCell.h"

@implementation tagListCCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
}
@end

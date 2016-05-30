//
//  NakedBookDateCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookDateCell.h"

@implementation NakedBookDateCell

- (void)setDate:(NSDate *)date
{
//    NSString *dateStr = [Utility getYYYYMMDD:date];
//    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
//    self.dateLabel.text =  [NSString stringWithFormat:@"%@,%@ %@",dateArr[2],[Utility ZYY:[dateArr[1]integerValue]],dateArr[0]];
    
    self.dateLabel.text = [Utility get_book_YYYYMMDD:date];
    
    self.timeLabel.text = (![[Utility get_book_YYYYMMDD:date] isEqualToString:[Utility get_book_YYYYMMDD:[NSDate date]]])?@"9:00":[Utility getHHMM:[NSDate date]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

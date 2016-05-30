//
//  NakedEventsFilterSegmentCell.m
//  NakedHub
//
//  Created by naked.Zuolin on 16/5/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedEventsFilterSegmentCell.h"

@implementation NakedEventsFilterSegmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _segmentedLabel.text = [GDLocalizableClass getStringForKey:@"I what to go to events happening in:"];
    
    [_segmentedControl setTitle:[GDLocalizableClass getStringForKey:@"My Building"] forSegmentAtIndex:0];
    [_segmentedControl setTitle:[GDLocalizableClass getStringForKey:@"My City"] forSegmentAtIndex:1];
    [_segmentedControl setTitle:[GDLocalizableClass getStringForKey:@"Anywhere"] forSegmentAtIndex:2];
    
    [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)segmentChanged:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            if (_SelectSegmentedControl) {
                [mixPanel track:@"Filter_myBuilding" properties:logInDic];
                _SelectSegmentedControl(@"MYHUB");
            }
        }
            break;
        case 1:
        {
            if (_SelectSegmentedControl) {
                [mixPanel track:@"Filter_myCity" properties:logInDic];
                _SelectSegmentedControl(@"MYCITY");
            }
        }
            break;
        case 2:
        {
            if (_SelectSegmentedControl) {
                [mixPanel track:@"Filter_anywhere" properties:logInDic];
                _SelectSegmentedControl(@"ALL");
            }
        }
            break;
        default:
            break;
    }
}


@end

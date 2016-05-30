//
//  NakedEAIntroCell.h
//  NakedHub
//
//  Created by 朱明 on 16/3/8.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEAIntroCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;


@end

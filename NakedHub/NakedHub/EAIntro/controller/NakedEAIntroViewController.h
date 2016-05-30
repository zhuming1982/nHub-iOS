//
//  ViewController.h
//  NakedHub
//
//  Created by 朱明 on 16/3/7.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedEAIntroViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)Login:(UIButton *)sender;

@end


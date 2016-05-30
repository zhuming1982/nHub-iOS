//
//  ViewController.h
//  Menu
//
//  Created by ZhuMing on 16/3/2.
//  Copyright © 2016年 ZhuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NakedHubSlidingControllerDataSource;
@protocol NakedHubSlidingControllerDelegate;


@interface NakedHubSlidingController : UIViewController

@property (nonatomic, assign)id<NakedHubSlidingControllerDataSource> datasouce;
@property (nonatomic, assign)id<NakedHubSlidingControllerDelegate> delegate;
-(void)reloadData;
@end

@protocol NakedHubSlidingControllerDataSource <NSObject>
@optional
// pageNumber
- (NSInteger)numberOfPageInFJSlidingController:(NakedHubSlidingController *)fjSlidingController;

// index -> UIViewController
- (UIViewController *)fjSlidingController:(NakedHubSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index;

// index -> Title
- (NSString *)fjSlidingController:(NakedHubSlidingController *)fjSlidingController titleAtIndex:(NSInteger)index;

// textNomalColor
- (UIColor *)titleNomalColorInFJSlidingController:(NakedHubSlidingController *)fjSlidingController;

// textSelectedColor
- (UIColor *)titleSelectedColorInFJSlidingController:(NakedHubSlidingController *)fjSlidingController;

// lineColor
- (UIColor *)lineColorInFJSlidingController:(NakedHubSlidingController *)fjSlidingController;

// titleFont
- (CGFloat)titleFontInFJSlidingController:(NakedHubSlidingController *)fjSlidingController;
@end

@protocol NakedHubSlidingControllerDelegate <NSObject>

@optional
// selctedIndex
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedIndex:(NSInteger)index;
// selectedController
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedController:(UIViewController *)controller;
// selectedTitle
- (void)fjSlidingController:(NakedHubSlidingController *)fjSlidingController selectedTitle:(NSString *)title;
@end
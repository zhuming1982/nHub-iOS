//
//  ViewController.m
//  Menu
//
//  Created by ZhuMing on 16/3/2.
//  Copyright © 2016年 ZhuMing. All rights reserved.
//

#import "NakedHubSlidingController.h"
#import "HMSegmentedControl.h"


@interface NakedHubSlidingController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger willIndex;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *segmentTitles;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation NakedHubSlidingController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}
-(void)instance{
    
    self.currentIndex = 0;
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44);
    self.pageController.dataSource = self;
    self.pageController.delegate   = self;
    [self.view addSubview:self.pageController.view];
}

-(void)reloadData{
    
    self.viewControllers  = [NSMutableArray array];
    self.segmentTitles  = [NSMutableArray array];
    NSInteger num = 0;
    if ([self.datasouce respondsToSelector:@selector(numberOfPageInFJSlidingController:)]) {
        num = [self.datasouce numberOfPageInFJSlidingController:self];
    }
    
    for (NSInteger i = 0 ; i < num; i++) {
        if ([self.datasouce respondsToSelector:@selector(fjSlidingController:controllerAtIndex:)]) {
            
            UIViewController *vc = [self.datasouce fjSlidingController:self controllerAtIndex:i];
            [self.viewControllers addObject:vc];
            
        }
    }
    for (NSInteger i = 0 ; i < num; i++) {
        if ([self.datasouce respondsToSelector:@selector(fjSlidingController:titleAtIndex:)]) {
            NSString *title = [self.datasouce fjSlidingController:self titleAtIndex:i];
            [self.segmentTitles addObject:title];
        }
    }
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.segmentTitles];
    _segmentedControl.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:49.0/255.0 blue:44.0/255.0 alpha:0.6];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segmentedControl.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44);
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(-1, 10, 0, 10);
    
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorHeight = 2.0;
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir-book" size:14]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    _segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    [self.pageController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self instance];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)indexOfViewController:(UIViewController *)viewController{
    return [self.viewControllers indexOfObject:viewController];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    index --;
    
    return self.viewControllers[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    index++;
    
    return self.viewControllers[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSInteger index = [self indexOfViewController:pendingViewControllers[0]];
    self.willIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        NSInteger index = [self indexOfViewController:previousViewControllers[0]];
        NSInteger nextIndex = 0;
        if (index > self.willIndex) {
            nextIndex = index - 1;
        }else if (index < self.willIndex){
            nextIndex = index + 1;
        }
        
        [self.segmentedControl setSelectedSegmentIndex:nextIndex animated:YES];
        [self callBackWithIndex:nextIndex];
    }
}
-(void)callBackWithIndex:(NSInteger)index{
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(fjSlidingController:controllerAtIndex:)]) {
        [self.delegate fjSlidingController:self selectedController:self.viewControllers[index]];
    }
    if ([self.delegate respondsToSelector:@selector(fjSlidingController:selectedTitle:)]) {
        [self.delegate fjSlidingController:self selectedTitle:self.segmentTitles[index]];
    }
    if ([self.delegate respondsToSelector:@selector(fjSlidingController:selectedIndex:)]) {
        [self.delegate fjSlidingController:self selectedIndex:index];
    }
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    __weak NakedHubSlidingController *weakSelf = self;
    if (self.currentIndex == 0) {
        
        [mixPanel track:@"Login_Email" properties:logOutDic];
        
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }else if (self.currentIndex < index){
        [mixPanel track:@"Login_teamCode" properties:logOutDic];
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }else{
        [mixPanel track:@"Login_Phone" properties:logOutDic];
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  NakedHub
//
//  Created by 朱明 on 16/3/7.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import "NakedEAIntroViewController.h"
#import <ESConveyorBelt/ESConveyorBelt.h>
#import "NakedEAIntroCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ESConveyorFlowLayout.h"
#import "UINavigationBar+Awesome.h"


@interface NakedEAIntroViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) ESConveyorController *ConveyorController;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScorllerView;
@property (weak, nonatomic) IBOutlet UIButton *joinNow;
@property (weak, nonatomic) IBOutlet UIButton *loginIn;

@end

@implementation NakedEAIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.joinNow setTitle:[GDLocalizableClass getStringForKey:@"JOIN NOW"] forState:UIControlStateNormal];
    [self.loginIn setTitle:[GDLocalizableClass getStringForKey:@"LOGIN"]
                  forState:UIControlStateNormal];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_bgScorllerView setContentSize:CGSizeMake(_bgScorllerView.frame.size.width*5, _bgScorllerView.frame.size.height)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JoinNow"]) {
        
        [mixPanel track:@"Guide_joinNow" properties:logOutDic];
    }
    if ([segue.identifier isEqualToString:@"Login"]) {
        
        [mixPanel track:@"Guide_login" properties:logOutDic];
    }
    
    if ([segue.identifier isEqualToString:@"imageView"]) {
        ((ESConveyorController *)segue.destinationViewController).numberOfPages = 5;
    
        NSString *imageName;
        if (([Utility isiPhone5]||[Utility isiPhone4])) {
            imageName = @"nakedIphone5";
        }
        else if ([Utility isiPhone6])
        {
            imageName = @"hubimages";
        }
        else
        {
            imageName = @"hubimages6p";
        }
        
        ESConveyorElement *bg = [ESConveyorElement elementForImageNamed:imageName];
        bg.inEffects = @[@(ESConveyorEffectParallax60)];
        bg.outEffects = @[@(ESConveyorEffectParallax60)];
        bg.paginationEffects = @[@(ESConveyorEffectParallax40)];
        bg.inPage = 0;
        bg.outPage = 5;
         ((ESConveyorController *)segue.destinationViewController).elements = @[bg];
        if (!_ConveyorController) {
            _ConveyorController = ((ESConveyorController *)segue.destinationViewController);
            _ConveyorController.collectionView.delegate = self;
        }
    }
    else if ([segue.identifier isEqualToString:@"gotoRegister"]){
        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NakedEAIntroCell *EAIntroCell = (NakedEAIntroCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NakedEAIntroCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
    [EAIntroCell.titleLabel setText:[GDLocalizableClass getStringForKey:@"Manifesto"]];
        [EAIntroCell.contentLabel setText:
         [GDLocalizableClass getStringForKey:@"naked Hub is born out of a sea change in ethos: answer to your calling, not your boss; abandon “work life balance” and embrace “work life blur” "]];
    
    }
    else if (indexPath.row == 1) {
        [EAIntroCell.titleLabel setText:[GDLocalizableClass getStringForKey:@"Hub Network"]];
                                [EAIntroCell.contentLabel setText:[GDLocalizableClass getStringForKey:@"With over 10 locations in Shanghai and a coming expansion across Asia, naked Hub provides you with first-class facilities and a network anywhere you need to work."]];
    }
    else if (indexPath.row == 2) {
        [EAIntroCell.titleLabel setText:[GDLocalizableClass getStringForKey:@"THE COMMUNITY"]];
        [EAIntroCell.contentLabel setText:[GDLocalizableClass getStringForKey:@"The naked Hub online and offline community actually solves your business problems! Get help, answers and support from this diverse community."]];
    }
    else if (indexPath.row == 3) {
        [EAIntroCell.titleLabel setText:[GDLocalizableClass getStringForKey:@"THE PERKS"]];
        [EAIntroCell.contentLabel setText:[GDLocalizableClass getStringForKey:@"Membership at naked Hub offers you the benefits of corporate work with 21st century freedom. Save money on valuable services and products."]];
    }
    else if (indexPath.row == 4) {
        [EAIntroCell.titleLabel setText:[GDLocalizableClass getStringForKey:@"Why wait?"]];
        [EAIntroCell.contentLabel setText:[GDLocalizableClass getStringForKey:@"Get started with a membership today.  You’re only a few taps away from joining a vibrant community that knows what working naked is all about."]];
    }
    return EAIntroCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _CollectionView.frame.size;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1000) {
        [self.ConveyorController.collectionView setContentOffset:scrollView.contentOffset animated:NO];
         [self.CollectionView setContentOffset:scrollView.contentOffset animated:NO];
        self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    }
}

- (IBAction)Login:(UIButton *)sender {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
    [[UIApplication sharedApplication].delegate window].rootViewController = tabBarVC;
}
@end

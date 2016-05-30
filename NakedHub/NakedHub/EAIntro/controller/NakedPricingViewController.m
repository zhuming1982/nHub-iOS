//
//  NakedPricingViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/16.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPricingViewController.h"
#import <iCarousel/iCarousel.h>
#import "carouselView.h"
#import "Utility.h"
#import "HttpRequest.h"
#import "NakedMemberShipModel.h"
#import "NakedRegisterFirstViewController.h"

#import "UINavigationBar+Awesome.h"

@interface NakedPricingViewController ()<iCarouselDataSource,iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *Carousel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carouselHeight;
@property (nonatomic,strong) NSArray<NakedMemberShipModel*> *MemberShipList;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberShipLabel;


@end

@implementation NakedPricingViewController

- (void)GetMemberShipList
{
    @weakify(self)
    [HttpRequest getWithUrl:memberShip_list andViewContoller:self andHudMsg:@"" andAttributes:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            @strongify(self)
            NSError *error;
            self.MemberShipList = [MTLJSONAdapter modelsOfClass:[NakedMemberShipModel class] fromJSONArray:response[@"result"] error:&error];
            if (!error) {
                if (self.MemberShipList.count>0) {
                    for (NakedMemberShipModel *model in self.MemberShipList) {
                        model.count = 1;
                    }
                    self.pageControl.numberOfPages = _MemberShipList.count;
                    [self setSubViewWithMemberShip:_MemberShipList[0]];
                }
                [_Carousel reloadData];
            }
        }
    }];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.carouselHeight.constant = [Utility carouselViewHeight];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.memberShipLabel setText:[GDLocalizableClass getStringForKey:@"Choose Membership"]];
//    [self.introductionLabel setText:[GDLocalizableClass getStringForKey:@"(Single User) Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."]];
    [self.bottomBtn setTitle:[GDLocalizableClass getStringForKey:@"CONTINUE · ¥0"]
                    forState:UIControlStateNormal];
    
    _Carousel.type = iCarouselTypeRotary;
    _Carousel.scrollSpeed = 0.5;
    _Carousel.bounces = NO;
    _Carousel.pagingEnabled = YES;
    [self GetMemberShipList];//加载数据
//    @weakify(self)
//    [[RACObserve(_bottomBtn, titleLabel.text) map:^id(NSString *value) {
//        return @(![value isEqualToString:@"CONTINUE · ¥0"]);
//    }]subscribeNext:^(id x) {
//        @strongify(self)
//        self.bottomBtn.enabled =
//        [x boolValue];
//        [self.bottomBtn setBackgroundColor:[x boolValue]?[UIColor colorWithRed:233.0/255.0 green:144.0/255.0 blue:29.0/255.0 alpha:1.0]:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.MemberShipList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[carouselView alloc]init];
    }
    //价格订单上 “＋－按钮”点击的block
    @weakify(self)
    [((carouselView*)view) setAddAndSubtractCallBack:^(UIButton *sender) {
        @strongify(self)
        if (sender.tag==100) {
            //--
            if (self.MemberShipList[self.Carousel.currentItemIndex].count != 1) {
                self.MemberShipList[self.Carousel.currentItemIndex].count--;
            }
        }
        else
        {
            //++
            self.MemberShipList[self.Carousel.currentItemIndex].count++;
        }
        if (self.MemberShipList.count>0) {
        //订购数量（至少数量为1）
        ((carouselView*)self.Carousel.currentItemView).countLabel.text = [NSString stringWithFormat:@"%li",(long)self.MemberShipList[self.Carousel.currentItemIndex].count];
        //订单详情提示内容
        [self setSubViewWithMemberShip:self.MemberShipList[self.Carousel.currentItemIndex]];
        }
    }];
    if (self.MemberShipList.count>0) {
    ((carouselView*)view).memberShipModel = _MemberShipList[index];
        
    }
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI * 0.2;
        }
        case iCarouselOptionRadius:
        {
            return value * 1.6;
        }
        case iCarouselOptionTilt:
        {
            return 0.7;
        }
        case iCarouselOptionSpacing:
        {
            return value * 0.7;
        }
        default:
        {
            return value;
        }
    }
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (void)carouselDidScroll:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
    [self setSubViewWithMemberShip:_MemberShipList[carousel.currentItemIndex]];
}

-(void)setSubViewWithMemberShip:(NakedMemberShipModel*)model
{
    
    self.introductionLabel.text = model.introduction;
    
 NSString *btnTitle = [GDLocalizableClass getStringForKey:@"CONTINUE"];
    
    [_bottomBtn setTitle:[NSString stringWithFormat:@"%@ · ¥%.f",btnTitle,model.price*model.count] forState:UIControlStateNormal];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using
    if ([segue.identifier isEqualToString:@"Continue"]) {
        [mixPanel track:@"ChooseMembership_Continue" properties:logOutDic];
    }
    
    ((NakedRegisterFirstViewController*)[segue destinationViewController]).attr = [NSMutableDictionary dictionaryWithDictionary:@{@"memberShip":_MemberShipList[_Carousel.currentItemIndex]}];
    
}


@end

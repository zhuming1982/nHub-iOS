//
//  NakedPaymentListViewController.m
//  NakedHub
//
//  Created by zhuming on 16/3/17.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedPaymentListViewController.h"
#import "NakedPaymentCell.h"
#import "Utility.h"
#import "HttpRequest.h"
#import "NakedMemberShipModel.h"
#import "NakedOrderModel.h"
#import "NakedLetGoViewController.h"
#import "WXApi.h"
#import "NHWXPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TTTAttributedLabel.h"
#import "NakedHubBenifitViewController.h"

@interface NakedPaymentListViewController ()<UITableViewDelegate,TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *weiChatView;
@property (weak, nonatomic) IBOutlet UIView *aliPayView;
@property (strong, nonatomic) IBOutlet UIView *secionHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
@property (weak, nonatomic) IBOutlet UILabel *youHaveSelectedLabel;
@property (nonatomic,strong) NakedOrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UILabel *weChatPayLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *byCountingLabel;
@property (nonatomic,strong) NakedMemberShipModel *memberShipM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;


@end

@implementation NakedPaymentListViewController

- (void)loadOrder
{
    @weakify(self)
    if (!_memberShipM) {
        _memberShipM = self.attr[@"memberShip"];
//        [self.attr removeObjectForKey:@"memberShip"];
    }
    [self.attr setObject:@(_memberShipM.count) forKey:@"monthes"];
    [self.attr setObject:@(_memberShipM.memberShipId) forKey:@"membershipId"];

    [HttpRequest postWithURLSession:pay_open_addRegOrder andViewContoller:self andHudMsg:@"" andAttributes:_attr andBlock:^(id response, NSError *error) {
        @strongify(self)
        if (!error) {
            _orderModel = [MTLJSONAdapter modelOfClass:[NakedOrderModel class] fromJSONDictionary:response[@"result"] error:nil];
            NSString  *aliTitle = [GDLocalizableClass getStringForKey:@"Pay via ALIPAY"];
            self.alipayLabel.text = [NSString stringWithFormat:@"%@  ·   ¥%.f",aliTitle,self.orderModel.price];
            
            NSString  *weChatTitle = [GDLocalizableClass getStringForKey:@"Pay via WeChat Pay"];
            self.weChatPayLabel.text = [NSString stringWithFormat:@"%@   ·   ¥%.f",weChatTitle,self.orderModel.price];
            [self.tableView reloadData];
        }
        else
        {
            [Utility showErrorWithVC:self andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        }
        
    }];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ORDER_PAY_NOTIFICATION object:nil];
}
#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [mixPanel track:@"Pay_Terms&Conditions" properties:logOutDic];
    NakedHubBenifitViewController *benifitVC =(NakedHubBenifitViewController *) [Utility pushViewControllerWithStoryboard:@"More" andViewController:@"NakedHubBenifitViewController" andParent:self];
    benifitVC.fromPageType = FromPayment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxPayResponse:) name:ORDER_PAY_NOTIFICATION object:nil];
    self.title = [GDLocalizableClass getStringForKey:@"Payment"];
    [self.youHaveSelectedLabel setText:[GDLocalizableClass getStringForKey:@"You have selected:"]];

    self.byCountingLabel.delegate = self;
    self.byCountingLabel.linkAttributes =  @{((__bridge NSString *)kCTUnderlineStyleAttributeName):@(YES)};
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.byCountingLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    
    
    [self.byCountingLabel setText:[GDLocalizableClass getStringForKey:@"By continuing, you agree to the Terms and Conditions of the naked Hub membership agreement."]  afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         //设置可点击文字的范围
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:[GDLocalizableClass getStringForKey:@"Terms and Conditions"] options:NSCaseInsensitiveSearch];
         
         //设定可点击文字的的大小
         UIFont *boldSystemFont = [UIFont fontWithName:@"Avenir-Book" size:14];
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
         
         if (font) {
             
             //设置可点击文本的大小
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
             
             //设置可点击文本的颜色
//             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:boldRange];
             
             CFRelease(font);
             
         }
         return mutableAttributedString;
     }];
    
    
   NSRange boldRange = [self.byCountingLabel.text rangeOfString:[GDLocalizableClass getStringForKey:@"Terms and Conditions"] options:NSCaseInsensitiveSearch];
    
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    
    if ([urlStr isEqualToString:@"en"]) {
        urlStr = payment_en;
    }
    else if ([urlStr isEqualToString:@"zh"]){
        urlStr = payment_zh ;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self.byCountingLabel addLinkToURL:url withRange:boldRange];
    
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableViewHeight.constant = [Utility PaymentListViewHeight];
    [Utility configSubView:_weiChatView CornerWithRadius:6.0];
    [Utility configSubView:_aliPayView CornerWithRadius:6.0];
    [self loadOrder];
    if ([Utility isiPhone4]) {
        _tableViewHeightConstraint.constant = 190;
    }
    if ([Utility isiPhone5]) {
        _tableViewHeightConstraint.constant = 310;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(void)WxPayResponse:(NSNotification*)not
{
    if ([not.object boolValue]) {
        [self showHint:[GDLocalizableClass getStringForKey:@"Payment Successful!"]];
        NakedLetGoViewController *LetGoVC = (NakedLetGoViewController *)[Utility pushViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedLetGoViewController" andParent:self];
        LetGoVC.orderId = self.orderModel.orderId;
    }
    else
    {
        [self showHint:[GDLocalizableClass getStringForKey:@"Payment Failure!"]];
    }
    
}
-(void)payMentWithType:(NSString*)type{
    
    @weakify(self)
    [HttpRequest postWithURLSession:pay_open_pay
                   andViewContoller:self andHudMsg:@""
                      andAttributes:[NSMutableDictionary dictionaryWithDictionary:@{@"payType":type,@"orderId":@(_orderModel.orderId)}]
                           andBlock:^(id response, NSError *error) {
                               if (!error) {
                                   @strongify(self)
                                   if ([type isEqualToString:@"WECHAT_PAY"]) {
                                       PayReq *request = [[PayReq alloc] init];
                                       if (![response[@"result"] isKindOfClass:[NSNull class]])
                                       {
                                           NHWXPayModel *payModel = [MTLJSONAdapter modelOfClass: [NHWXPayModel class]fromJSONDictionary:response[@"result"] error:nil];
                                           request.partnerId = payModel.partnerId;
                                           request.prepayId= payModel.prepayId;
                                           request.package = payModel.packageValue;
                                           request.nonceStr= payModel.nonceStr;
                                           request.timeStamp = [payModel.timeStamp integerValue];
                                           request.sign=  payModel.sign;
                                           [WXApi sendReq:request];
                                       }
                                       
                                   }
                                   else
                                   {
                                       
                                       if (response[@"result"]&&![response[@"result"] isKindOfClass:[NSNull class]]) {
                                           if (response[@"result"][@"payString"]) {
                                               [[AlipaySDK defaultService]payOrder:response[@"result"][@"payString"] fromScheme:ALIPAYSCHEME callback:^(NSDictionary *resultDic) {
                                                   if ([resultDic[@"success"] isEqualToString:@"%5C%22true%5C%22"]||[resultDic[@"resultStatus"] integerValue] == 9000) {
                                                       [self showHint:@"支付成功！"];
                                                       NakedLetGoViewController *LetGoVC = (NakedLetGoViewController *)[Utility pushViewControllerWithStoryboard:@"EAIntro" andViewController:@"NakedLetGoViewController" andParent:self];
                                                       LetGoVC.orderId = self.orderModel.orderId;
                                                   }
                                               }];

                                           }
                                        }
                                   }
                               }
    }];
}


- (IBAction)aliPayAction:(id)sender {
    [self payMentWithType:@"ALIPAY"];
    [mixPanel track:@"Pay_ALIPAY" properties:logOutDic];
}

- (IBAction)weiChatPay:(id)sender {
    [self payMentWithType:@"WECHAT_PAY"];
    
    [mixPanel track:@"Pay_WECHAT_PAY" properties:logOutDic];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NakedPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NakedPaymentCell" forIndexPath:indexPath];
    if (_orderModel) {
         cell.orderModel = _orderModel;
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _secionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([Utility isiPhone4]) {
        return 44.0;
    }
    return _secionHeaderView.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

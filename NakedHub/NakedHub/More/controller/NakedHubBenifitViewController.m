//
//  NakedHubBenifitViewController.m
//  NakedHub
//
//  Created by Winky on 16/4/19.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedHubBenifitViewController.h"

@interface NakedHubBenifitViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation NakedHubBenifitViewController

- (void)viewDidLoad {
    
     [super viewDidLoad];
    
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];

    if (self.fromPageType == FromBenifit) {
      
        self.title = [GDLocalizableClass getStringForKey:@"Benefits"];
        
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = benefit_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = benefit_zh;
        }
    }
    else if (self.fromPageType == FromPayment){
        self.title = [GDLocalizableClass getStringForKey:@"Terms&Conditions"];
        
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = payment_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = payment_zh ;
        }
    }
    else if (self.fromPageType == FromWhatDescription){
        
        self.title = [GDLocalizableClass getStringForKey:@"What’s this?"];
        
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = what_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = what_zh;
        }
    }
    else if (self.fromPageType == FromCommunity)
    {
        self.title = [GDLocalizableClass getStringForKey:@"Community Guidelines"];
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = community_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = community_zh;
        }
    }
    else if (self.fromPageType == FromEvents)
    {
        self.title = [GDLocalizableClass getStringForKey:@"Events"];
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = events_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = events_zh;
        }
    }

    else if (self.fromPageType == FromGuide)
    {
        self.title = [GDLocalizableClass getStringForKey:@"Guide"];
        if ([urlStr isEqualToString:@"en"]) {
            urlStr = guide_en;
        }
        else if ([urlStr isEqualToString:@"zh"]){
            urlStr = guide_zh;
        }
    }
    else if (self.fromPageType == FromSupport)
    {
        NSString *localStr ;
        if ([urlStr isEqualToString:@"en"]) {
            localStr = @"en_US";
        }
        else if ([urlStr isEqualToString:@"zh"]){
            localStr = @"zh_CN";
        }
        
        urlStr = [NSString stringWithFormat:@"%@page/support-h5.html?token=%@&locale=%@",urlClass.urlStr,[[NSUserDefaults standardUserDefaults]objectForKey:tokenName],localStr];
        self.title = [GDLocalizableClass getStringForKey:@"Support"];
    }
    NSURL  *bingUrl = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:bingUrl];
    
    _WebView.scrollView.bounces = NO;
    _WebView.delegate = self;
    [_WebView loadRequest:request];
   
}

#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"ios"])
    {
        if ([[URL resourceSpecifier] isEqualToString:@"back"]) {
            [self BackBtnAction:nil];
            return NO;
        }
    }
    return YES;
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
    if (webView.isLoading) {
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]){
            [storage deleteCookie:cookie];
        }
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        return;
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
- (IBAction)BackBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

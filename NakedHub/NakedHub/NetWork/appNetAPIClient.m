//
//  appNetAPIClient.m
//  SportSocial
//
//  Created by ZhuMing on 15/10/14.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "appNetAPIClient.h"
#import "NetWorkAPIUrl.h"
#import "APIModel.h"
#import "Utility.h"

@implementation appNetAPIClient



+ (instancetype)sharedClient {
    static appNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[Utility isTestServer]?APP_Test_APIBASEURL:APP_APIBASEURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end

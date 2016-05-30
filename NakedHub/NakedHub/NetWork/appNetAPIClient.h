//
//  appNetAPIClient.h
//  SportSocial
//
//  Created by ZhuMing on 15/10/14.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface appNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end

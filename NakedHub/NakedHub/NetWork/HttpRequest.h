//
//  HttpRequest.h
//  SportSocial
//
//  Created by ZhuMing on 15/10/14.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpRequest : NSObject


+ (void)postWithURLSession:(NSString *)url
          andViewContoller:(UIViewController*)vc
                 andHudMsg:(NSString*)hudMsg
             andAttributes:(NSMutableDictionary *)attributes
                  andBlock:(void (^)(id response, NSError *error))block;

+(void)upLoadWithUrl:(NSString *)url
andUploadAddressBooks:(NSData *)AddressBooks
            andBlock:(void (^)(id, NSError *))block;


+ (void)getWithUrl:(NSString *)url
  andViewContoller:(UIViewController*)vc
         andHudMsg:(NSString*)hudMsg
     andAttributes:(NSMutableDictionary *)attributes
          andBlock:(void (^)(id response, NSError *error))block;

+ (void)upLoadWithUrl:(NSString *)url
     andViewContoller:(UIViewController*)vc
            andHudMsg:(NSString*)hudMsg
   andUploadImageName:(NSString*)imgName
            andImages:(NSMutableArray*)images
        andAttributes:(NSMutableDictionary *)attributes
             andBlock:(void (^)(id response, NSError *error))block;

+ (NSURLSessionDataTask *)postWithURLSession:(NSString *)url
                            andViewContoller:(UIViewController*)vc
                               andAttributes:(NSMutableDictionary *)attributes
                                    andBlock:(void (^)(id response, NSError *error))block;

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                    andViewContoller:(UIViewController*)vc
                       andAttributes:(NSMutableDictionary *)attributes
                            andBlock:(void (^)(id response, NSError *error))block;

@end

//
//  HttpRequest.m
//  SportSocial
//
//  Created by ZhuMing on 15/10/14.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "HttpRequest.h"
#import "appNetAPIClient.h"
#import "UIViewController+HUD.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "Constant.h"
#import "Utility.h"
#import "TSMessage.h"
#import "NakedHubTeamCodeViewController.h"
#import "NakedLoginWithPhoneViewController.h"
#import "NakedLoginWithEmailViewController.h"
#import "GDLocalizableClass.h"

@implementation HttpRequest


+ (NSURLSessionDataTask *)postWithURLSession:(NSString *)url
          andViewContoller:(UIViewController*)vc
             andAttributes:(NSMutableDictionary *)attributes
                  andBlock:(void (^)(id response, NSError *error))block
{
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    if (attributes) {
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    else{
        attributes = [NSMutableDictionary dictionaryWithCapacity:0];
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] POST:url parameters:attributes success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]integerValue]==410) {
            [Utility logOutWithVC:vc andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
        }
        else if ([responseObject[@"code"]integerValue]==561)
        {
            [Utility logOutWithVC:vc andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
        }
        else
        {
            if (block) {
                block(responseObject, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [vc hideHud];
        if (block) {
            block(nil, error);
        }
    }];
    //[UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    return task;
}

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
  andViewContoller:(UIViewController*)vc
     andAttributes:(NSMutableDictionary *)attributes
          andBlock:(void (^)(id response, NSError *error))block
{
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    if (attributes) {
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    else{
        attributes = [NSMutableDictionary dictionaryWithCapacity:0];
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] GET:url parameters:attributes success:^(NSURLSessionDataTask * __unused task, id JSON)
                                  {
                                      [vc hideHud];
                                      if ([JSON[@"code"]integerValue]==200) {
                                          
                                          if (block) {
                                              block(JSON,nil);
                                          }
                                      }
                                      else if ([JSON[@"code"]integerValue] == 410)
                                      {
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                          [Utility logOutWithVC:vc andIsCycle:YES];
                                        
                                      }
                                      else if ([JSON[@"code"]integerValue]==561)
                                      {
                                          [Utility logOutWithVC:vc andIsCycle:YES];
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                      }
                                      else
                                      {
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                      [vc hideHud];
//                                      [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
                                      if (block) {
                                          block(nil, error);
                                      }
                                  }];
    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    return task;
}




+ (void)postWithURLSession:(NSString *)url
          andViewContoller:(UIViewController*)vc
                 andHudMsg:(NSString*)hudMsg
             andAttributes:(NSMutableDictionary *)attributes
                  andBlock:(void (^)(id response, NSError *error))block
{
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    if (attributes) {
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    else{
        attributes = [NSMutableDictionary dictionaryWithCapacity:0];
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    
    if (vc){
        [vc showHudInView:vc.view hint:hudMsg];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kDeviceTokenName]) {
        [attributes setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kDeviceTokenName] forKey:@"deviceToken"];
    }
    NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] POST:url parameters:attributes success:^(NSURLSessionDataTask *task, id responseObject) {
        [vc hideHud];
        
        
        if ([responseObject[@"code"]integerValue]==410) {
            
            [Utility logOutWithVC:vc andIsCycle:YES];

            [Utility showErrorMessage:responseObject[@"msg"]];

            return ;
        }
        if ([responseObject[@"code"]integerValue]==561)
        {
            [Utility logOutWithVC:vc andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
            return ;
        }
        
        if ([vc isKindOfClass:[NakedHubTeamCodeViewController class]]||
            [vc isKindOfClass:[NakedLoginWithPhoneViewController class]]||
            [vc isKindOfClass:[NakedLoginWithEmailViewController class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSString *TokenString = [[response allHeaderFields] valueForKey:@"HEADER_SECURITY_TOKEN"];
            if(TokenString.length>0){
                [[NSUserDefaults standardUserDefaults]setObject:TokenString forKey:tokenName];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            if (block) {
                block(responseObject,nil);
            }
            return ;
        }
        
        if ([responseObject[@"code"]integerValue]==200){
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSString *TokenString = [[response allHeaderFields] valueForKey:@"HEADER_SECURITY_TOKEN"];
            if(TokenString.length>0)
            {
                [[NSUserDefaults standardUserDefaults]setObject:TokenString forKey:tokenName];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            if (block) {
                block(responseObject,nil);
            }
        }
        else{
            [Utility showErrorWithVC:vc andMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [vc hideHud];
        if (block) {
            block(nil, error);
        }
    }];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

+ (void)getWithUrl:(NSString *)url
  andViewContoller:(UIViewController*)vc
         andHudMsg:(NSString*)hudMsg
     andAttributes:(NSMutableDictionary *)attributes
          andBlock:(void (^)(id response, NSError *error))block
{
    NSString  *urlStr = [[GDLocalizableClass userLanguage] substringWithRange:NSMakeRange(0, 2)];
    if (attributes) {
        [attributes setValue:urlStr forKey:localeLanguage];
    }
    else{
        attributes = [NSMutableDictionary dictionaryWithCapacity:0];
        [attributes setValue:urlStr forKey:localeLanguage];
    }

    if (vc&&hudMsg){
        [vc showHudInView:vc.view hint:hudMsg];
    }
    [[appNetAPIClient sharedClient]GET:url parameters:attributes progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress = %@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [vc hideHud];
        if ([responseObject[@"code"]integerValue]==200) {
            
            if (block) {
                block(responseObject,nil);
            }
        }
        else if ([responseObject[@"code"]integerValue] == 410)
        {
            [Utility showErrorMessage:responseObject[@"msg"]];
            [Utility logOutWithVC:vc andIsCycle:YES];
            //                                          double delayInSeconds = 2.0;
            //                                          dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //                                          dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //                                          dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            //                                              [Utility logOutWithVC:vc andIsCycle:YES];
            //                                              NSLog(@"Grand Center Dispatch!");
            //                                          });
        }
        else if ([responseObject[@"code"]integerValue]==561)
        {
            [Utility logOutWithVC:vc andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
        }
        else
        {
            if ([responseObject[@"code"]integerValue]==551) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"removeData" object:nil];
            }
            [Utility showErrorMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [vc hideHud];
        [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
        if (block) {
            block(nil, error);
        }
    }];
   /* NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] GET:url parameters:attributes success:^(NSURLSessionDataTask * __unused task, id JSON)
                                  {
                                       [vc hideHud];
                                      if ([JSON[@"code"]integerValue]==200) {
                                         
                                          if (block) {
                                              block(JSON,nil);
                                          }
                                      }
                                      else if ([JSON[@"code"]integerValue] == 410)
                                      {
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                          [Utility logOutWithVC:vc andIsCycle:YES];
//                                          double delayInSeconds = 2.0;
//                                          dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                                          dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                          dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//                                              [Utility logOutWithVC:vc andIsCycle:YES];
//                                              NSLog(@"Grand Center Dispatch!"); 
//                                          });
                                      }
                                      else if ([JSON[@"code"]integerValue]==561)
                                      {
                                          [Utility logOutWithVC:vc andIsCycle:YES];
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                      }
                                      else
                                      {
                                          [Utility showErrorMessage:JSON[@"msg"]];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                      [vc hideHud];
                                      [Utility showErrorWithVC:vc andMessage:[GDLocalizableClass getStringForKey:@"network.disconnection"]];
                                      if (block) {
                                          block(nil, error);
                                      }
                                  }];*/
    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

//上传通讯录
+(void)upLoadWithUrl:(NSString *)url  andUploadAddressBooks:(NSData *)AddressBooks andBlock:(void (^)(id, NSError *))block
{
    NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] POST:url parameters:[NSMutableDictionary dictionaryWithDictionary:@{@"AddressBooks":AddressBooks}] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]integerValue]==561)
        {
            [Utility logOutWithVC:nil andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
            return ;
        }
        if ([responseObject[@"code"]integerValue] == 410)
        {
            [Utility logOutWithVC:nil andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
            return;
        }
        
        if ([responseObject[@"code"]integerValue]==200) {
            if (block) {
                block(responseObject,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}


+ (void)upLoadWithUrl:(NSString *)url
  andViewContoller:(UIViewController*)vc
         andHudMsg:(NSString*)hudMsg
   andUploadImageName:(NSString*)imgName
            andImages:(NSMutableArray*)images
     andAttributes:(NSMutableDictionary *)attributes
          andBlock:(void (^)(id response, NSError *error))block
{
    if (vc){
        [vc showHudInView:vc.view hint:hudMsg];
    }
    
    NSURLSessionDataTask *task = [[appNetAPIClient sharedClient] POST:url parameters:attributes constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (images) {
            if (images.count>1) {
                int i=0;
                for (id objc in images)
                {
                    if ([objc isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage*)objc;
                        NSData *idata2 = UIImageJPEGRepresentation(image, 0.5);
                        [formData  appendPartWithFileData:idata2 name:imgName fileName:[NSString stringWithFormat:@"%@.JPEG",imgName] mimeType:@"image/jpeg"];
                    }
                    else{
                        
                        NSDictionary *dic = (NSDictionary*)objc;
                        NSData *idata2 = UIImageJPEGRepresentation(dic[@"image"], 0.5);
                        [formData  appendPartWithFileData:idata2 name:dic[@"key"] fileName:[NSString stringWithFormat:@"%@.JPEG",dic[@"key"]] mimeType:@"image/jpeg"];
                    }
                    i++;
                }
            }
            else if (images.count==1)
            {
                if ([images[0] isKindOfClass:[UIImage class]]) {
                    NSData *idata = UIImageJPEGRepresentation(images[0], 0.5);
                    [formData  appendPartWithFileData:idata name:imgName fileName:[NSString stringWithFormat:@"%@.JPEG",imgName] mimeType:@"image/JPEG"];
                }
                else
                {
                    NSDictionary *dic = (NSDictionary*)images[0];
                    NSData *idata2 = UIImageJPEGRepresentation(dic[@"image"], 0.5);
                    [formData  appendPartWithFileData:idata2 name:dic[@"key"] fileName:[NSString stringWithFormat:@"%@.JPEG",dic[@"key"]] mimeType:@"image/jpeg"];
                }
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [vc hideHud];
        if ([responseObject[@"code"]integerValue]==410) {
//            [Utility showErrorWithVC:vc andMessage:responseObject[@"msg"]];
            [Utility logOutWithVC:vc andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
//            double delayInSeconds = 2.0;
//            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//                [Utility logOutWithVC:vc andIsCycle:YES];
//                NSLog(@"Grand Center Dispatch!");
//            });
//            return ;
        }
        
        if ([responseObject[@"code"]integerValue] == 561)
        {
            [Utility logOutWithVC:nil andIsCycle:YES];
            [Utility showErrorMessage:responseObject[@"msg"]];
            return ;
        }
        
        if ([responseObject[@"code"]integerValue]==200) {
            
            if (block) {
                block(responseObject,nil);
            }
        }
        else
        {
            [Utility showErrorWithVC:vc andMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [vc hideHud];
        if (block) {
            block(nil, error);
        }
    }];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end

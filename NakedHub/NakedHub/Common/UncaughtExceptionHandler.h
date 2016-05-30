//
//  UncaughtExceptionHandler.h
//  SportSocial
//
//  Created by ZhuMing on 16/1/28.
//  Copyright © 2016年 cloudrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);


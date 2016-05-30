//
//  URLSingleton.m
//  NakedHub
//
//  Created by nanqian on 16/4/29.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "URLSingleton.h"

@implementation URLSingleton

static URLSingleton *shareURLSingleton = nil;
+(URLSingleton *)sharedURLSingleton{
    @synchronized(self){
        if(shareURLSingleton == nil){
            shareURLSingleton = [[self alloc] init];
        }
    }
    return shareURLSingleton;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (shareURLSingleton == nil) {
            shareURLSingleton = [super allocWithZone:zone];
            return  shareURLSingleton;
        }
    }
    return nil;
}

@end

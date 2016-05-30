//
//  GYSQL.h
//  SportSocial
//
//  Created by ZhuMing on 15/10/28.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "NHChatUserModel.h"

@interface GYSQL : NSObject

+(BOOL)saveNewUser:(NHChatUserModel*)aUser;

+(BOOL)UpLoadUser:(NHChatUserModel*)aUser;

+(NSMutableArray*)selectUserWith:(NSString*)userID;

@end

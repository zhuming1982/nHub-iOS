//
//  GYSQL.m
//  SportSocial
//
//  Created by ZhuMing on 15/10/28.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "GYSQL.h"



@implementation GYSQL

+(BOOL)saveNewUser:(NHChatUserModel*)aUser
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [GYSQL checkTableCreatedInDb:db];
    NSString *insertStr=@"INSERT INTO 'GYUser' ('userId','userName','avatar') VALUES (?,?,?)";
    BOOL worked = [db executeUpdate:insertStr,aUser.UserId,aUser.UserName,aUser.UserAvatarUrl];
//    FMDBQuickCheck(worked);
    [db close];
    return worked;
}
+(BOOL)UpLoadUser:(NHChatUserModel*)aUser
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    BOOL worked=[db executeUpdate:@"update GYUser set userName=?, avatar=? where userId=?",aUser.UserName,aUser.UserAvatarUrl,aUser.UserId];
//    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(NSMutableArray*)selectUserWith:(NSString*)userID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    };
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *s = [db executeQuery:@"SELECT * FROM GYUser WHERE userId=?",userID];
    while ([s next]) {
        NHChatUserModel *userModel = [[NHChatUserModel alloc]init];
        userModel.UserId = [s stringForColumn:@"userId"];
        userModel.UserAvatarUrl = [s stringForColumn:@"avatar"];
        userModel.UserName = [s stringForColumn:@"userName"];
        [arr addObject:userModel];
    }
    return arr;
}



+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'GYUser' ('userId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE, 'userName' VARCHAR, 'avatar' VARCHAR)";
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}


@end

//
//  VerifyRegexTool.m
//  SportSocial
//
//  Created by wings on 15/12/3.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import "VerifyRegexTool.h"
#import "DateTools.h"
#import "Constant.h"

@implementation VerifyRegexTool

//验证是否不为空
+ (BOOL)verifyIsNotEmpty:(NSString *)str
{
    if (!str) return NO;
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

//正则验证
+ (BOOL)verifyText:(NSString *)text withRegex:(NSString *)regex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

//验证军官证或警官证
//必须是下面两种格式中的一种
//格式一：4到20位数字
//格式二：大于或等于10位并且小于等于20位（中文按两位），并满足以下规则
//1）必须有“字第”两字
//2）“字第”前面有至少一个字符
//3）“字第”后是4位以上数字
+ (BOOL)verifyCardNumberWithSoldier:(NSString *)value
{
    NSString *s1 = @"^\\d*$";
    NSString *s2 = @"^.{1,}字第\\d{4,}$";
    //NSString *s3 = @"^([A-Za-z0-9\\u4e00-\\u9fa5])*$";
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([VerifyRegexTool verifyText:value withRegex:s1]) {
        NSString *s11 = @"^\\d{4,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", s11];
        return [pred evaluateWithObject:value];
    } else if ([self lengthUsingChineseCharacterCountByTwo:value] >= 10
               && [self lengthUsingChineseCharacterCountByTwo:value] <= 20) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", s2];
        return [pred evaluateWithObject:value];
    }
    
    return NO;
}

+ (NSUInteger)lengthUsingChineseCharacterCountByTwo:(NSString *)string{
    NSUInteger count = 0;
    for (NSUInteger i = 0; i< string.length; ++i) {
        if ([string characterAtIndex:i] < 256) {
            count++;
        } else {
            count += 2;
        }
    }
    return count;
}

//验证身份证是否成年且小于100岁****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (BOOL)verifyIDCardHadAdult:(NSString *)card
{
    NSString *birtday = [VerifyRegexTool getIDCardBirthday:card];   //****年**月**日
    //转换为****-**-**
    birtday = [birtday stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    birtday = [birtday stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    birtday = [birtday stringByReplacingOccurrencesOfString:@"日" withString:@""];
    birtday = [NSString stringWithFormat:@"%@ 00:00",birtday];
    NSDate *dateBirtday = [NSDate dateWithString:birtday formatString:kDateFormateYMDHM];
    NSInteger year = [dateBirtday year];   //得到年数
    
    if (year >= 18 && year < 100) {
        return YES;
    } else {
        return NO;
    }
}

////验证身份证加上指定天数是否大于指定number的类型
//+ (BOOL)verifyIDCardMoreThanPointDate:(NSString *)card withNumber:(NSInteger)number withAddTimeInterval:(NSTimeInterval)interval withDateType:(DateType)dateType {
//    NSString *birtday = [VerifyRegexTool getIDCardBirthday:card];   //****年**月**日
//    //转换为****-**-**
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"日" withString:@""];
//    birtday = [NSString stringWithFormat:@"%@ 00:00",birtday];
//    NSDate *dateBirtday = [NSDate dateFromString:birtday];
//    NSDate *today = [NSDate dateFromStringWithoutTime:[[NSDate date] strDate]];
//    NSDate *pointDate = [today dateByAddingTimeInterval:interval];
//    
//    //tempDate为number后的日期
//    NSDate *tempDate = [pointDate dateAddNumber:-number withDateType:dateType];  //临界日期
//    if ([dateBirtday earlierDate:tempDate] == dateBirtday) {  //如果生日＋指定天数大雨tempdate，则通过
//        return YES;
//    } else {
//        return NO;
//    }
//}
//
////验证身份证加上指定天数是否小于指定number的类型
//+ (BOOL)verifyIDCardLessThanPointDate:(NSString *)card withNumber:(NSInteger)number withAddTimeInterval:(NSTimeInterval)interval withDateType:(DateType)dateType
//{
//    NSString *birtday = [VerifyRegexTool getIDCardBirthday:card];   //****年**月**日
//    //转换为****-**-**
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
//    birtday = [birtday stringByReplacingOccurrencesOfString:@"日" withString:@""];
//    birtday = [NSString stringWithFormat:@"%@ 00:00",birtday];
//    NSDate *dateBirtday = [NSDate dateFromString:birtday];
//    NSDate *today = [NSDate dateFromStringWithoutTime:[[NSDate date] strDate]];
//    NSDate *pointDate = [today dateByAddingTimeInterval:interval];
//    
//    //tempDate为number后的日期
//    NSDate *tempDate = [pointDate dateAddNumber:-number withDateType:dateType];  //临界日期
//    if ([tempDate earlierDate:dateBirtday] == tempDate) {  //如果生日＋指定天数小于tempdate，则通过
//        return YES;
//    } else {
//        return NO;
//    }
//}

//得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSString *)getIDCardBirthday:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@年%@月%@日",[card substringWithRange:NSMakeRange(6,4)], [card substringWithRange:NSMakeRange(10,2)], [card substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

//得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSInteger)getIDCardSex:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([card length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 0;
    } else {
        return 1;
    }
}
@end

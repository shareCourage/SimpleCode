//
//  NSString+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/21.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#import "NSString+PHCategory.h"
#import "CommonCrypto/CommonDigest.h"
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
static NSString *token = @"Itisgoomesimplifiedappprivatekeyandcouldnotbegetbysomeoneelse~~!!123800";
@implementation NSString (PHCategory)

- (NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}
- (NSString *)myMD5
{
    NSString *str = [NSString stringWithFormat:@"%@%@", self, token];
    return [str MD5];
}
#pragma mark 使用SHA1加密字符串
- (NSString *)SHA1
{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+ (NSString *)uuid{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**获取UUID*/
+ (NSString *)currentDeviceNSUUID
{
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    NSMutableString *str = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", uuid]];
    NSArray *array = [str componentsSeparatedByString:@" "];
    NSString *currentUUID = [array lastObject];
    return currentUUID;
}

+ (NSString *)iPhoneDeviceNumber{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return @"Unknown";
}

/**
 *  根据系统的时区，获取一个数值，比如beijing 28800 Tokyo 32400
 *
 */
+ (NSString *)getNowDateTimezone
{
    NSDate *date = [NSDate date];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    return [NSString stringWithFormat:@"%.f",interval];
}


#pragma mark 十进制转换为十六进制
- (NSString *)toHexString
{
    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%02lx", (long)[self integerValue]]];
    return hexString;
}

#pragma mark 十六进制转换为十进制
- (NSString *)hexToDecimal
{
    long decimalNum = strtoul([self UTF8String], 0, 16);
    
    NSString *str = [NSString stringWithFormat:@"%ld", decimalNum];
    
    return str;
}

/**
 *  金额转大写
 *
 */
+ (NSString *)digitUppercaseWithMoney:(NSString *)money
{
    NSMutableString *moneyStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    NSArray *MyScale=@[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *MyBase=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *integerArray = @[@"拾", @"佰", @"仟", @"万", @"拾万", @"佰万", @"仟万", @"亿", @"拾亿", @"佰亿", @"仟亿", @"兆", @"拾兆", @"佰兆", @"仟兆"];
    
    
    NSMutableString *M = [[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for(NSInteger i=moneyStr.length;i>0;i--)
    {
        NSInteger MyData=[[moneyStr substringWithRange:NSMakeRange(moneyStr.length-i, 1)] integerValue];
        [M appendString:MyBase[MyData]];
        
        //判断是否是整数金额
        if (i == moneyStr.length) {
            NSInteger l = [[moneyStr substringFromIndex:1] integerValue];
            if (MyData > 0 &&
                l == 0 ) {
                NSString *integerString = @"";
                if (moneyStr.length > 3) {
                    integerString = integerArray[moneyStr.length-4];
                }
                [M appendString:[NSString stringWithFormat:@"%@%@",integerString,@"元整"]];
                break;
            }
        }
        
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue]==0
           && i != 1
           && i != 2)
        {
            [M appendString:@"元整"];
            break;
        }
        [M appendString:MyScale[i-1]];
    }
    return M;
}

/**
 1、如果有设置传入参数:(时间格式)，则使用传入的格式
 2、否则，将时间转化成这样的格式：MM/dd/yyyy HH:mm:ss
 */
- (NSString *)convertGpstimeToDateFormate:(NSString *)dateF
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (dateF.length == 0) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:dateF];
    }
    return [dateFormatter stringFromDate:date];
}


- (CLLocationCoordinate2D)coordAndLatFirst:(BOOL)latFirst {
    CLLocationCoordinate2D coord;
    NSArray *obj = [NSArray seprateString:self characterSet:@","];
    if (obj.count != 2) {
        return coord = kCLLocationCoordinate2DInvalid;
    }
    if (latFirst) {
        coord.latitude = [(NSString *)[obj firstObject] doubleValue];
        coord.longitude  = [(NSString *)[obj lastObject] doubleValue];
    } else {
        coord.longitude = [(NSString *)[obj firstObject] doubleValue];
        coord.latitude  = [(NSString *)[obj lastObject] doubleValue];
    }
    return coord;
}

- (NSString *)insertSymbolString:(NSString *)symbol atIndex:(NSUInteger)index {
    if (index > self.length) return nil;
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",self];
    [mString insertString:symbol atIndex:index];
    return [mString copy];
}

+ (NSString *)returnBitString:(NSUInteger)number {
    char data[number];
    for (int x = 0; x < number; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:number encoding:NSUTF8StringEncoding];
}



- (CGSize)stringSizeWithFont:(UIFont *)font height:(CGFloat)height {
    CGSize size;
    NSAttributedString *atrString = [[NSAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, atrString.length);
    NSDictionary *dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return  size;
}

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    CGSize returnSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return returnSize;
}


+ (NSString *)formatShowDateTime:(NSDate *)needDate
{
    if (needDate == nil) return @"";
    
    @try {
        //实例化一个NSDateFormatter对象
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"1分钟前";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24*2){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                //                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needDate]];
                dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:needDate]];
            }else{
                ////  昨天
                //                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needDate]];
                [dateFormatter setDateFormat:@"dd"];
                NSString *beforeYesDay = [dateFormatter stringFromDate:needDate];
                NSString *yesDay = [dateFormatter stringFromDate:nowDate];
                NSInteger num = [yesDay integerValue] - [beforeYesDay integerValue];
                if (num == 1) {
                    dateStr = @"昨天";
                }else{
                    [dateFormatter setDateFormat:@"MM月dd日"];
                    dateStr = [dateFormatter stringFromDate:needDate];
                }
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+(NSString *)dateDifferenceYourDate:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    //传入的时间
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:dateFormat];
    NSDate *date = [formater dateFromString:dateStr];
    NSTimeInterval late=(int)[date timeIntervalSince1970];
    
    //格式化传入时间
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    NSString *userDateStr = [userFormatter stringFromDate:date];
    NSArray *userArr = [userDateStr componentsSeparatedByString:@":"];
    
    //当前时间
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now=(int)[nowDate timeIntervalSince1970];
    
    //当前时间字符串表示法
    NSDateFormatter *nowFormatter = [[NSDateFormatter alloc] init];
    [nowFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    NSString *nowDateStr = [nowFormatter stringFromDate:nowDate];
    //计算当前时间与当天零差多少秒
    NSArray *tempArr = [nowDateStr componentsSeparatedByString:@":"];
    int todayZero = [tempArr[3] intValue]*3600 + [tempArr[4] intValue]*60 + [tempArr[5] intValue];
    //时间差（秒）
    NSTimeInterval cha = now-late;
    
    NSString *timeString=@"";
    //五分钟内返回
    if (cha<5*60) {
        timeString = @"5分钟内";
    }
    //时间差大于五分钟小于一个小时内
    else if (cha>5*60 && cha<3600) {
        timeString = [NSString stringWithFormat:@"%d", (int)(cha/60)];
        timeString = [NSString stringWithFormat:@"%@分钟前",timeString];
        
    }
    //当天之内
    else if (cha/3600>1 && cha<todayZero) {
        timeString = [NSString stringWithFormat:@"%@:%@",userArr[3],userArr[4]];
    }
    //昨天
    else if (cha>todayZero && cha<(todayZero+24*60*60))
    {
        timeString = [NSString stringWithFormat:@"昨天 %@:%@",userArr[3],userArr[4]];
    }
    //昨天之前
    else if(cha >(todayZero+24*60*60)){
        timeString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",userArr[0],userArr[1],userArr[2],userArr[3],userArr[4]];
    }
    
    return timeString;
    
}

@end










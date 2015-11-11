//
//  NSString+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/21.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PHCategory)

- (NSString *)MD5;
- (NSString *)myMD5;
- (NSString *)SHA1;//SHA1加密
+ (NSString *)uuid;//uuid
+ (NSString *)currentDeviceNSUUID;//vendor

+ (NSString *)iPhoneDeviceNumber;//设备是iPhone几，比如iPhone6

/**
 *  根据系统的时区，获取一个数值，比如beijing 28800 Tokyo 32400
 *
 */
+ (NSString *)getNowDateTimezone;

/**
 *  金额转大写
 *
 */
+ (NSString *)digitUppercaseWithMoney:(NSString *)money;

/**
 *  返回多少位的随机字符串
 *
 */
+ (NSString *)returnBitString:(NSUInteger)number;

/**
 1、如果有设置传入参数:(时间格式)，则使用传入的格式
 2、否则，将时间转化成这样的格式：MM/dd/yyyy HH:mm:ss
 */
- (NSString *)convertGpstimeToDateFormate:(NSString *)dateF;

/**
 *  114.012863,22.64119的转化
 *
 */
- (CLLocationCoordinate2D)coordAndLatFirst:(BOOL)latFirst;

- (NSString *)insertSymbolString:(NSString *)symbol atIndex:(NSUInteger)index;


- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font;
- (CGSize)stringSizeWithFont:(UIFont *)font height:(CGFloat)height;
@end









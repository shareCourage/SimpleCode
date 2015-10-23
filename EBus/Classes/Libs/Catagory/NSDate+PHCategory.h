//
//  NSDate+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PHCategory)
/**
 *  将NSDate按格式，转换成NSString
 */
- (NSString *)stringFromDateFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
/**
 *  将NSString按指定格式,转换成NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateHoursAgo:(int)hour;
+ (NSDate *)midnightDateFromDate:(NSDate *)date;
+ (NSDate *)lastMinuteFromDate:(NSDate *)date;

#if 0
+ (NSString *)thisYear;
+ (NSString *)thisMonth;
+ (NSString *)theDateToday;
+ (NSString *)thisHour;
+ (NSString *)thisMinute;
+ (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate;
+ (NSDate *)noondayFromDate:(NSDate *)date;

+ (NSString *)genderFromIDNumber:(NSString *)number;    //male results "M", female returns "F"
+ (NSDate *)birthdayFromIDNumber:(NSString *)number;    //returns the date with format like "yyyyMMdd"
- (NSUInteger)daysAgo;
- (NSString *)weekString;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSDate *)dateHoursAgo:(int)hour;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

- (NSString*)timestamp;
#endif
@end

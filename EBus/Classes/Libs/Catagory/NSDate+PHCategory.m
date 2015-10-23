//
//  NSDate+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define kDateFormatYearOnly                 @"yyyy"
#define kDateFormatMonthOnly                @"MM"
#define kDateFormatTheDateTodayOnly         @"dd"
#define kDateFormatTimeOnly                 @"HH:mm:ss"
#define kDateFormatHourAndMinuteOnly        @"HH:mm"
#define kDateFormatHourOnly                 @"HH"
#define kDateFormatMinuteOnly               @"mm"
#define kDateFormatChinese                  @"yyyy年MM月dd日"
#define kDateFormatNatural                  @"yyyyMMdd"
#define kDateFormatNaturalLong              @"yyyyMMddHHmmss"
#define kDateFormatHorizontalLine           @"yyyy-MM-dd"
#define kDateFormatHorizontalLineLong       @"yyyy-MM-dd HH:mm:ss"
#define kDateFormatSlash                    @"yyyy/MM/dd"
#define kDateFormatSlashLong                @"yyyy/MM/dd HH:mm:ss"
#define kDateFormatShortChinese             @"MM月dd日 HH:mm"
#import "NSDate+PHCategory.h"

@implementation NSDate (PHCategory)
/**
 *  将NSDate按格式，转换成NSString
 */
- (NSString *)stringFromDateFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [outputFormatter setDateFormat:format];
    return [outputFormatter stringFromDate:self];
}
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

/**
 *  将NSString按指定格式,转换成NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}


- (NSDate *)dateAfterDay:(int)day{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}
- (NSDate *)dateHoursAgo:(int)hour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setHour:hour];
    NSDate *dateAfterHours = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterHours;
}


+ (NSDate *)midnightDateFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"00:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}
+ (NSDate *)lastMinuteFromDate:(NSDate *)date{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"23:59:59";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}












#if 0
+ (NSString *)thisYear
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatYearOnly];
}

+ (NSString *)thisMonth
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMonthOnly];
}

+ (NSString *)theDateToday
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatTheDateTodayOnly];
}

+ (NSString *)thisHour
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatHourOnly];
}

+ (NSString *)thisMinute
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMinuteOnly];
}

+ (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate
{
    NSTimeInterval timeInterval = 60 * 60 * 24 * dayInterval;
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:sinceDate];
}


+ (NSDate *)noondayFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"12:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}



+ (NSString *)genderFromIDNumber:(NSString *)number
{
    NSString *result = @"M";
    NSUInteger length = [number length];
    if (!([number characterAtIndex:length - 2] % 2)) {
        result = @"F";
    }
    return result;
}

+ (NSDate *)birthdayFromIDNumber:(NSString *)number
{
    NSUInteger length = [number length];
    NSString *birthday = nil;
    if (length == 18) {
        birthday = [number substringWithRange:NSMakeRange(6, 8)];
    } else if (length == 15) {
        birthday = [NSString stringWithFormat:@"%d%@",19,[number substringWithRange:NSMakeRange(6, 6)]];
    }
    return [self dateFromString:birthday dateFormat:kDateFormatNatural];
}



- (NSInteger)year{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps year];
}
- (NSInteger)month{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps month];
}
- (NSInteger)day{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps day];
}
- (NSInteger)hour{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps hour];
}
- (NSInteger)minute{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps minute];
}
- (NSInteger)second{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps second];
}



+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
    return [NSDate timestampFormatString];
}
#endif
@end

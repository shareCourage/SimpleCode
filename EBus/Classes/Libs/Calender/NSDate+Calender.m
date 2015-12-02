//
//  NSDate+Calender.m
//  SimpleCalendar
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Jason Lee. All rights reserved.
//

#import "NSDate+Calender.h"

@implementation NSDate (Calender)
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

- (NSUInteger)weeklyOrdinality
{
//    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];

    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)monthlyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}

- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
#pragma clang diagnostic pop
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];//该时间点
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;//一个月前
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;//一个月后
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)weekNumberInCurrentMonth
{
    NSUInteger firstDay = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger weeksCount = [self numberOfWeeksInCurrentMonth];
    NSUInteger weekNumber = 0;
    
    NSDateComponents *c = [self YMDComponents];
    NSUInteger startIndex = [[self firstDayOfCurrentMonth] monthlyOrdinality];
    NSUInteger endIndex = startIndex + (7 - firstDay);
    for (int i = 0; i < weeksCount; ++i) {
        if (c.day >= startIndex && c.day <= endIndex) {
            weekNumber = i;
            break;
        }
        startIndex = endIndex + 1;
        endIndex = startIndex + 6;
    }
    
    return weekNumber;
}
@end

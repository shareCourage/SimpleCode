
//
//  PHCalenderDay.m
//  SimpleCalendar
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Jason Lee. All rights reserved.
//

#import "PHCalenderDay.h"

@implementation PHCalenderDay
+ (instancetype)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    PHCalenderDay *calendarDay = [[self alloc] init];
    calendarDay.year = year;
    calendarDay.month = month;
    calendarDay.day = day;
    return calendarDay;
}

- (BOOL)isEqualTo:(PHCalenderDay *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

@end

//
//  EBUserInfo.m
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBUserInfo.h"
#import "PHCalenderKit.h"

@implementation EBUserInfo
@synthesize loginName = _loginName;
@synthesize loginId = _loginId;
@synthesize sztNo = _sztNo;
singleton_implementation(EBUserInfo)

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadCurrentDate];
    }
    return self;
}

#pragma mark - Private Method
- (void)reloadCurrentDate
{
    self.currentDate = [NSDate date];
    NSDateComponents *c = [self.currentDate YMDComponents];
    self.currentCalendarDay = [PHCalenderDay calendarDayWithYear:c.year month:c.month day:c.day];
    NSUInteger weeksCount = [self.currentDate numberOfWeeksInCurrentMonth];
    self.calendarDays = [NSMutableArray arrayWithCapacity:weeksCount * 7];
    [self calculateDaysInPreviousMonthWithDate:self.currentDate];
    [self calculateDaysInCurrentMonthWithDate:self.currentDate];
    [self calculateDaysInFollowingMonthWithDate:self.currentDate];
}

#pragma mark - method to calculate days in previous, current and the following month.

- (void)calculateDaysInPreviousMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];
    
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];
    NSUInteger partialDaysCount = weeklyOrdinality - 1;
    
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];
    
    self.daysInPreviousMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInPreviousMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];
    NSDateComponents *components = [date YMDComponents];
    
    self.daysInCurrentMonth = [NSMutableArray arrayWithCapacity:daysCount];
    for (int i = 1; i < daysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInCurrentMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    self.daysInFollowingMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInFollowingMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

- (NSString *)loginName {
    if (_loginName == nil) {
        _loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginNameForKey"];
    }
    return _loginName;
}

- (void)setLoginName:(NSString *)loginName {
    _loginName = loginName;
    [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:@"loginNameForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)loginId {
    if (_loginId == nil) {
        _loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginIdForKey"];
    }
    return _loginId;
}

- (void)setLoginId:(NSString *)loginId {
    _loginId = loginId;
    [[NSUserDefaults standardUserDefaults] setObject:loginId forKey:@"loginIdForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)sztNo {
    if (_sztNo == nil) {
        _sztNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"sztNoForKey"];
    }
    return _sztNo;
}
- (void)setSztNo:(NSString *)sztNo {
    _sztNo = sztNo;
    [[NSUserDefaults standardUserDefaults] setObject:sztNo forKey:@"sztNoForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

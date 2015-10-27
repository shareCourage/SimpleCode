//
//  NSDate+Calender.h
//  SimpleCalendar
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calender)
- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSUInteger)monthlyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDateComponents *)YMDComponents;

- (NSUInteger)weekNumberInCurrentMonth;
@end

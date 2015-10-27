//
//  PHCalenderDay.h
//  SimpleCalendar
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHCalenderDay : NSObject
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) NSUInteger month;
@property (nonatomic, assign) NSUInteger year;

+ (instancetype)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (BOOL)isEqualTo:(PHCalenderDay *)day;

- (NSDate *)date;
@end

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
@synthesize userLocation = _userLocation;
singleton_implementation(EBUserInfo)

- (instancetype)init {
    self = [super init];
    if (self) {
        _userLocation = kCLLocationCoordinate2DInvalid;
        _singletonMapView = YES;
        _maMapView = [[MAMapView alloc] init];
        _maMapView.showsUserLocation = YES;
        _maMapView.allowsBackgroundLocationUpdates = YES;
        _maMapView.userTrackingMode = MAUserTrackingModeFollow;
        _currentDate = [NSDate date];
        [self reloadCurrentDate];
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    [_daysInCurrentMonth removeAllObjects];
    [_daysInFollowingMonth removeAllObjects];
    [_daysInPreviousMonth removeAllObjects];
    [self reloadCurrentDate];
}

#pragma mark - Private Method
- (void)reloadCurrentDate
{
    NSDateComponents *c = [self.currentDate YMDComponents];
    _currentCalendarDay = [PHCalenderDay calendarDayWithYear:c.year month:c.month day:c.day];
    NSUInteger weeksCount = [self.currentDate numberOfWeeksInCurrentMonth];
    _calendarDays = [NSMutableArray arrayWithCapacity:weeksCount * 7];
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
    
    _daysInPreviousMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [_daysInPreviousMonth addObject:calendarDay];
        [_calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];
    NSDateComponents *components = [date YMDComponents];
    
    _daysInCurrentMonth = [NSMutableArray arrayWithCapacity:daysCount];
    for (int i = 1; i < daysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [_daysInCurrentMonth addObject:calendarDay];
        [_calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    _daysInFollowingMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        PHCalenderDay *calendarDay = [PHCalenderDay calendarDayWithYear:components.year month:components.month day:i];
        [_daysInFollowingMonth addObject:calendarDay];
        [_calendarDays addObject:calendarDay];
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


- (CLLocationCoordinate2D)userLocation {
    if (CLLocationCoordinate2DIsValid(_userLocation)) return _userLocation;
    CGFloat lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userLocationForKeyLat"];
    CGFloat lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userLocationForKeyLng"];
    if (lat == 0 || lng == 0) return CLLocationCoordinate2DMake(22.538313, 113.958002);
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
    return coord;
}
- (void)setUserLocation:(CLLocationCoordinate2D)userLocation {
    _userLocation = userLocation;
    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.latitude forKey:@"userLocationForKeyLat"];
    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.longitude forKey:@"userLocationForKeyLng"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

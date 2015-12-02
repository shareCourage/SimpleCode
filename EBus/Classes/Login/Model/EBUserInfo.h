//
//  EBUserInfo.h
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "Singleton.h"
@class PHCalenderDay;

@interface EBUserInfo : NSObject

singleton_interface(EBUserInfo)

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginId;
@property (nonatomic, copy) NSString *sztNo;
/* 用户日历上的当天 */
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong, readonly) PHCalenderDay *currentCalendarDay;
@property (nonatomic, strong, readonly) NSMutableArray *calendarDays; // 当前月份展示的日历天
@property (nonatomic, strong, readonly) NSMutableArray *daysInPreviousMonth;
@property (nonatomic, strong, readonly) NSMutableArray *daysInCurrentMonth;
@property (nonatomic, strong, readonly) NSMutableArray *daysInFollowingMonth;

@property (nonatomic, strong, readonly) MAMapView *maMapView;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign, getter = isSingletonMapView) BOOL singletonMapView;//决定VC是否用该单例中的地图

@end

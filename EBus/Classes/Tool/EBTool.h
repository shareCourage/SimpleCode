//
//  EBTool.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NSArray+MySeperateString.h"
#import "NSDictionary+PHCategory.h"
#import "UIButton+PHCategory.h"
#import "UIButton+EBButton.h"
#import "UILabel+PHCategory.h"
#import "NSDate+PHCategory.h"
#import "UIProgressView+PHCategory.h"
#import "UISlider+PHCategory.h"
#import "NSNumber+PHCategory.h"
#import "UIImage+PHCategory.h"
#import "UITextField+PHCategory.h"
#import "NSString+PHCategory.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+PHCategory.h"
#import "UIView+PHLayout.h"
#import "MBProgressHUD+MJ.h"
#import "UIColor+PHCategory.h"
#import "PHKeyValueObserver.h"
@class EBSearchResultModel, PHCalenderDay;

@interface EBTool : NSObject

+ (CLLocationManager *)locationManagerImplementation;

+ (BOOL)locationEnable;

+ (BOOL)presentLoginVC:(UIViewController *)vc completion:(void (^)())completion;

+ (BOOL)encoderObjectArray:(NSMutableArray *)memberArray path:(NSString *)filePath;
+ (NSMutableArray *)decoderObjectPath:(NSString *)filePath;

+ (NSString *)filePathOfLineId;
/*
 常用路线保存的路径
 */
+ (NSString *)usualLineFilePath;
/*
 *保存常用路线路线到本地
 */
+ (BOOL)saveUsualLineToLocalWithArray:(NSMutableArray *)lines;
/*
 *从本地获取常用路线
 */
+ (NSMutableArray *)usualLineArrayFromLocal;
/*
 *删除常用路线
 */
+ (BOOL)deleteUsualLineFile;
+ (BOOL)deleteLindIdFile;
+ (BOOL)deleteFilePath:(NSString *)filePath;
/*
 *保存该模型到本地
 */
+ (void)saveResultModelToLocal:(EBSearchResultModel *)result;
/*
 *正则表达式判断是否是电话号码
 */
+ (BOOL)isPureTelephoneNumber:(NSString*)string;

+ (NSString *)stringConnected:(NSArray *)array connectString:(NSString *)connectStr;

+ (void)openAppInitial;

/*
 *判断是否已经登录成功
 * 成功返回YES， 未登录返回NO
 */
+ (BOOL)loginEnable;

+ (BOOL)canOpenApplication:(NSString *)string;

+ (void)popToAttentionControllWithIndex:(NSUInteger)index controller:(UIViewController *)vc;

+ (NSString *)stringFromStatus:(NSInteger)status;
+ (NSString *)stringFromPayType:(NSInteger)payType;
+ (NSString *)stringFromZJType:(NSUInteger)certype;

+ (NSInteger)currentYear;
+ (NSInteger)currentMonth;
+ (NSInteger)currentDay;
+ (NSInteger)currentHour;
+ (NSInteger)currentMinute;
+ (NSInteger)currentSecond;

+ (UIImageView *)backgroundImageView;

+ (BOOL)eb_isWaitingWithDate:(NSString *)runDate startTime:(NSString *)startTime;
/*
 *全部过期日期返回YES，其它返回NO
 */
+ (BOOL)allOutDate:(NSArray *)sales startTime:(NSString *)startTime;
+ (NSString *)stringFromPHCalenderDay:(PHCalenderDay *)currentDay;
+ (NSString *)stringFromPHCalenderDay:(PHCalenderDay *)currentDay space:(NSString *)space;
+ (BOOL)isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2;
@end

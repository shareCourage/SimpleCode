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



@interface EBTool : NSObject

+ (CLLocationManager *)locationManagerImplementation;

+ (BOOL)locationEnable;

+ (BOOL)presentLoginVC:(UIViewController *)vc completion:(void (^)())completion;

+ (BOOL)encoderObjectArray:(NSMutableArray *)memberArray path:(NSString *)filePath;
+ (NSMutableArray *)decoderObjectPath:(NSString *)filePath;

/*
 *正则表达式判断是否是电话号码
 */
+ (BOOL)isPureTelephoneNumber:(NSString*)string;
@end

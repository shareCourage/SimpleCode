//
//  EBTool.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define PHArchiver_memberArray @"memberArray"
#import "EBTool.h"
#import "EBUserInfo.h"

#import "EBLoginViewController.h"
#import "PHNavigationController.h"
#import "PHTabBarController.h"
#import "EBAttentionController.h"
#import "PHCalenderDay.h"
#import "EBSearchResultModel.h"

@implementation EBTool

+ (NSString *)stringFromStatus:(NSInteger)status {
    NSString *string = nil;
    if (status == 0) {
        string = @"未支付";
    } else if (status == 1) {
        string = @"已取消";
    } else if (status == 2) {
        string = @"已支付";
    } else if (status == 3) {
        string = @"已退票";
    } else if (status == 4) {
        string = @"退款中";
    }
    return string;
}
+ (NSString *)stringFromPayType:(NSInteger)payType {
    NSString *payStr = nil;
    if (payType == 1) {
        payStr = @"支付宝";
    } else if (payType == 2) {
        payStr = @"微信";
    } else if (payType == 3) {
        payStr = @"深圳通";
    } else if (payType == 4) {
        payStr = @"免费证件";
    }
    return payStr;
}
+ (NSString *)stringFromZJType:(NSUInteger)certype {
    NSArray *array = @[@"《深圳市敬老优待证》",
                       @"《深圳暂住老年人免费乘车证》",
                       @"《残疾人证》",
                       @"《残疾人证》- 盲人",
                       @"《中国人民共和国残疾军人证》",
                       @"《中国人民共和国伤残人民警察证》",
                       @"《中国人民共和国伤残国家机关工作人员证》",
                       @"《中国人民共和国伤残民兵民工工作证》",
                       @"《中国人民共和国老干部离休荣誉证》",
                       @"《军官证》、《警官证》、《士兵证》",
                       @"实名制免费'深圳通'",];
    if (certype > array.count) return nil;
    return array[certype - 1];
}
+ (CLLocationManager *)locationManagerImplementation {
    // 1. 实例化定位管理器
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    // 2. 设置代理
    // 3. 定位精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    // 4.请求用户权限：分为：⓵只在前台开启定位⓶在后台也可定位，
    //注意：建议只请求⓵和⓶中的一个，如果两个权限都需要，只请求⓶即可，
    //⓵⓶这样的顺序，将导致bug：第一次启动程序后，系统将只请求⓵的权限，⓶的权限系统不会请求，只会在下一次启动应用时请求⓶
    if (EB_iOS(8.0)) {
        //        [_locationManager requestWhenInUseAuthorization];//⓵只在前台开启定位 旅游
        [locationManager requestAlwaysAuthorization];//⓶在后台也可定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
    if (EB_iOS(9.0)) {
#ifdef __IPHONE_9_0
        locationManager.allowsBackgroundLocationUpdates = YES;
#endif
    }
    // 6. 更新用户位置
    [locationManager startUpdatingLocation];
    return locationManager;
}

+ (BOOL)locationEnable {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL enable = NO;
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        enable = YES;
    } else {
        enable = NO;
    }
    return enable;
}

+ (BOOL)presentLoginVC:(UIViewController *)vc completion:(void (^)())completion {
    if (!vc) return NO;
    UIViewController *mySelf = nil;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        mySelf = vc;
    } else if ([vc isKindOfClass:[UIViewController class]]){
        UINavigationController *navi = vc.navigationController;
        if (navi) {
            mySelf = navi;
        } else {
            mySelf = vc;
        }
    }
    NSString *loginName = [EBUserInfo sharedEBUserInfo].loginName;
    NSString *loginId = [EBUserInfo sharedEBUserInfo].loginId;
    if (loginName.length != 0 && loginId.length != 0) {
        if (completion) completion();
        return NO;
    }
    EBLoginViewController *login = [[EBLoginViewController alloc] init];
    login.formerVC = mySelf;
    PHNavigationController *loginNavi = [[PHNavigationController alloc] initWithRootViewController:login];
    [mySelf presentViewController:loginNavi animated:YES completion:^{
        if (completion) completion();
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:EBPresentLoginVCDidFinishNotification object:nil];
        });
    }];
    return YES;
}

/**
 *  数组归档
 *
 *  @param memberArray memberArray 接收的参数NSMutableArray
 *  @param filePath    filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)encoderObjectArray:(NSMutableArray *)memberArray path:(NSString *)filePath
{
    EBLog(@"%ld",(long)memberArray.count);
    NSMutableData *mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:memberArray forKey:PHArchiver_memberArray];
    [archiver finishEncoding];
    return [mutableData writeToFile:filePath atomically:YES];
}
/**
 *   数组解档
 *
 *  @param filePath filePath 文件路径
 *
 *  @return 返回一个NSMutableArray
 */
+ (NSMutableArray *)decoderObjectPath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *array = [unarc decodeObjectForKey:PHArchiver_memberArray];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:array];
    return mutableArray;
}

+ (NSString *)usualLineFilePath {
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documents stringByAppendingPathComponent:@"usualLine.arc"];
}

+ (NSMutableArray *)usualLineArrayFromLocal {
    return [EBTool decoderObjectPath:[EBTool usualLineFilePath]];
}
+ (BOOL)saveUsualLineToLocalWithArray:(NSMutableArray *)lines {
    return [EBTool encoderObjectArray:lines path:[EBTool usualLineFilePath]];
}
+ (void)saveResultModelToLocal:(EBSearchResultModel *)result {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[EBTool usualLineFilePath]]) {//如果存在这个路径
        NSMutableArray *usualLineArray = [EBTool usualLineArrayFromLocal];
        for (EBSearchResultModel *model in usualLineArray) {
            NSInteger modelLineId = [model.lineId integerValue];
            NSInteger resultLineId = [result.lineId integerValue];
            if (modelLineId == resultLineId) return;//如果已经有，那么就直接结束
        }
        [usualLineArray addObject:result];//能执行到这，说明没有该线路
        [EBTool saveUsualLineToLocalWithArray:usualLineArray];//保存该路线
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:result];
        [EBTool saveUsualLineToLocalWithArray:array];//保存该路线
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:EBDidSaveUsualLineNotification object:nil];
    });
}
// 验证手机号
#pragma mark ValidateCorrelation
//正则表达式判断是否是电话号码
+ (BOOL)isPureTelephoneNumber:(NSString*)string{
    if ([string length] == 0) {
        return NO;
    }
    //正则表达式
    NSString *regex=@"1\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (NSString *)stringConnected:(NSArray *)array connectString:(NSString *)connectStr
{
    NSString *string = nil;
    int i = 1;
    for (NSString *devID in array) {
        if (i == 1) {
            string = devID;
        }
        else{
            NSString *aaaa = [connectStr stringByAppendingString:devID];
            string = [string stringByAppendingString:aaaa];
        }
        i --;
    }
    return string;
}


+ (void)openAppInitial {
    if ([EBUserInfo sharedEBUserInfo].loginName.length != 0 && [EBUserInfo sharedEBUserInfo].loginId.length != 0) {
        NSDictionary *paramters = @{static_Argument_customerId : [EBUserInfo sharedEBUserInfo].loginId,
                                    static_Argument_customerName : [EBUserInfo sharedEBUserInfo].loginName};
        [EBNetworkRequest GET:static_Url_Open parameters:paramters dictBlock:^(NSDictionary *dict) {
        } errorBlock:^(NSError *error) {
        }];
        PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
        NSString *today = [NSString stringWithFormat:@"%ld%02ld%02ld",(unsigned long)currentDay.year, (unsigned long)currentDay.month, (unsigned long)currentDay.day];
        NSDictionary *parametersCustomer = @{static_Argument_id : [EBUserInfo sharedEBUserInfo].loginId,
                                             static_Argument_loginName : [EBUserInfo sharedEBUserInfo].loginName,
                                             static_Argument_loginCode : [today MD5]};
        [EBNetworkRequest GET:static_Url_CustomerDetail parameters:parametersCustomer dictBlock:^(NSDictionary *dict) {
            NSDictionary *returnData = dict[static_Argument_returnData];
            NSString *sztNo = returnData[static_Argument_sztNo];
            [EBUserInfo sharedEBUserInfo].sztNo = sztNo;
        } errorBlock:^(NSError *error) {
        }];
    }
}

+ (BOOL)loginEnable {
    if ([EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)canOpenApplication:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    return [[UIApplication sharedApplication] canOpenURL:url];
}


+ (void)popToAttentionControllWithIndex:(NSUInteger)index controller:(UIViewController *)vc {
    PHTabBarController *phTBC = (PHTabBarController *)vc.tabBarController;
    phTBC.mySelectedIndex = 2;
    NSArray *viewControlls = phTBC.viewControllers;
    PHNavigationController *navi = [viewControlls objectAtIndex:2];
    EBAttentionController *attentionVC = [navi.viewControllers firstObject];
    attentionVC.titleSelectIndex = index;
    [vc.navigationController popToRootViewControllerAnimated:NO];
}

+ (NSDateComponents *)dataComponent {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}

+ (NSInteger)currentYear {
    return [self dataComponent].year;
}
+ (NSInteger)currentMonth {
    return [self dataComponent].month;
}
+ (NSInteger)currentDay {
    return [self dataComponent].day;
}
+ (NSInteger)currentHour {
    return [self dataComponent].hour;
}
+ (NSInteger)currentMinute {
    return [self dataComponent].minute;
}
+ (NSInteger)currentSecond {
    return [self dataComponent].second;
}
@end






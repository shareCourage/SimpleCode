//
//  EBSponsorController.m
//  EBus
//
//  Created by Kowloon on 15/10/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSponsorController.h"
#import "EBSearchBusView.h"
#import "EBSelectPositionController.h"
#import "PHTabBarController.h"
#import "EBUserInfo.h"
#import "EBAttentionController.h"
#import "PHNavigationController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "EBTimeChooseView.h"

@interface EBSponsorController () <EBSearchBusViewDelegate, AMapSearchDelegate, EBTimeChooseViewDelegate>

@property (nonatomic, weak) EBSearchBusView *searchBusView;

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;
@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *onGeogName;
@property (nonatomic, copy) NSString *onStationName;
@property (nonatomic, copy) NSString *offGeogName;
@property (nonatomic, copy) NSString *offStationName;

@property (nonatomic, strong) AMapSearchAPI *searchPOI;
@property (nonatomic, assign) EBSearchBusClickType clickType;
@property (nonatomic, assign) BOOL timePickerViewAppear;
@property (nonatomic, weak) EBTimeChooseView *timeChooseView;
@end

@implementation EBSponsorController
- (AMapSearchAPI *)searchPOI {
    if (_searchPOI == nil) {
        _searchPOI = [[AMapSearchAPI alloc] init];
        _searchPOI.delegate = self;
    }
    return _searchPOI;
}

- (void)setTimePickerViewAppear:(BOOL)timePickerViewAppear {
    _timePickerViewAppear = timePickerViewAppear;
    if (timePickerViewAppear) {
        [UIView animateWithDuration:0.4f animations:^{
            self.timeChooseView.y = EB_HeightOfScreen - self.timeChooseView.height;
        }];
    } else {
        [UIView animateWithDuration:0.4f animations:^{
            self.timeChooseView.y = EB_HeightOfScreen;
        }];
    }
}

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    if (startTime) {
        self.searchBusView.startTimeTitle = [startTime insertSymbolString:@":" atIndex:2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起线路";
    self.view.backgroundColor = [UIColor whiteColor];
    self.myPositionCoord = kCLLocationCoordinate2DInvalid;
    self.endPositionCoord = kCLLocationCoordinate2DInvalid;
    [self searchBusViewImplementation];
    [self timeChooseViewImplementation];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipClick)]];
}
- (void)timeChooseViewImplementation {
    EBTimeChooseView *timeChooseView = [[EBTimeChooseView alloc] init];
    timeChooseView.delegate = self;
    timeChooseView.frame = CGRectMake(0, EB_HeightOfScreen, EB_WidthOfScreen, 200);
    [self.view addSubview:timeChooseView];
    self.timeChooseView = timeChooseView;
}

- (void)searchBusViewImplementation {
    EBSearchBusView *searchBusView = [[EBSearchBusView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    searchBusView.showStartTimeBtn = YES;
    searchBusView.delegate = self;
    [self.view addSubview:searchBusView];
    self.searchBusView = searchBusView;
}
- (void)tipClick {
    EBLog(@"%@",NSStringFromSelector(_cmd));
    self.timePickerViewAppear = NO;
}
#pragma mark -EBSearchBusViewDelegate
- (void)searchBusView:(EBSearchBusView *)searchBusView clickType:(EBSearchBusClickType)type {
    self.clickType = type;
    switch (type) {
        case EBSearchBusClickTypeMyPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeEndPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeStartTime:
            self.timePickerViewAppear = !self.timePickerViewAppear;
            break;
        case EBSearchBusClickTypeDeleteOfMyPosition:
            self.myPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeDeleteOfEndPosition:
            self.endPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeDeleteOfStartTime:
            self.startTime = nil;
            break;
        case EBSearchBusClickTypeSearch:
            [self searchSpecificBus];
            break;
        case EBSearchBusClickTypeExchange:
        {
            CLLocationCoordinate2D coord = self.myPositionCoord;
            self.myPositionCoord = self.endPositionCoord;
            self.endPositionCoord = coord;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Method
- (void)selectPosition:(EBSearchBusClickType)type {
    EB_WS(ws);
    EBSelectPositionController *selectC = [[EBSelectPositionController alloc] initWithExtraOption:^(NSString *title, NSString *district, CLLocationCoordinate2D coord) {
        if (type == EBSearchBusClickTypeMyPosition) {
            ws.searchBusView.myPositionTitle = title;
            ws.myPositionCoord = coord;
            ws.onStationName = title;
            if (!district) {//如果搜索不到城区，就再次搜索
                AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
                request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
                request.keywords = @"商业|大厦";
                request.types = @"餐饮服务|商务住宅|生活服务|交通设施服务";
                request.sortrule = 0;
                request.requireExtension = YES;
                //发起周边搜索
                [ws.searchPOI AMapPOIAroundSearch:request];
            } else {
                ws.onGeogName = district;
            }
        } else if (type == EBSearchBusClickTypeEndPosition) {
            ws.searchBusView.endPositionTitle = title;
            ws.endPositionCoord = coord;
            ws.offGeogName = district;
            ws.offStationName = title;
            if (!district) {
                AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
                request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
                request.keywords = @"商业|大厦";
                request.types = @"餐饮服务|商务住宅|生活服务|交通设施服务";
                request.sortrule = 0;
                request.requireExtension = YES;
                //发起周边搜索
                [ws.searchPOI AMapPOIAroundSearch:request];
            } else {
                ws.offGeogName = district;
            }
        }
    }];
    [self.navigationController pushViewController:selectC animated:YES];
}

- (void)searchSpecificBus {
    BOOL my = CLLocationCoordinate2DIsValid(self.myPositionCoord);
    BOOL end = CLLocationCoordinate2DIsValid(self.endPositionCoord);
    if (my && end && self.startTime.length != 0) {
        [self sponsorRequest];
    } else {
        if (!my) {
            [MBProgressHUD showError:@"上车站点不得为空" toView:self.view];
        } else if (!end) {
            [MBProgressHUD showError:@"下车站点不得为空" toView:self.view];
        } else {
            [MBProgressHUD showError:@"出发时间不得为空" toView:self.view];
        }
    }
}
#pragma mark - EBTimeChooseViewDelegate
- (void)timeChooseView:(EBTimeChooseView *)pickerView didSelectTime:(NSString *)time {
    self.startTime = time;
}

- (void)timeChooseView:(EBTimeChooseView *)pickerView didClickType:(EBTimeChooseViewClickType)type time:(NSString *)time{
    if (type == EBTimeChooseViewClickTypeOfSure) {
        self.startTime = time;
        self.timePickerViewAppear = NO;
    } else {
        self.timePickerViewAppear = NO;
    }
}


#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    AMapPOI *poi = [response.pois firstObject];
    EBLog(@"============%@============",poi.district);
    if (self.clickType == EBSearchBusClickTypeMyPosition) {
        self.onGeogName = poi.district;
    } else if (self.clickType == EBSearchBusClickTypeEndPosition) {
        self.offGeogName = poi.district;
    }
    
}

#pragma mark - Request
- (void)sponsorRequest{
    
    if (self.onGeogName.length != 0 && self.onStationName.length != 0 && self.offGeogName.length != 0 && self.offStationName.length != 0) {
        [MBProgressHUD showMessage:@"正在发起路线..." toView:self.view];
        NSDictionary *parameters = @{static_Argument_customerId     : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_customerName   : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_onGeogName     : self.onGeogName,
                                     static_Argument_onStationName  : self.onStationName,
                                     static_Argument_onLng          : @(self.myPositionCoord.longitude),
                                     static_Argument_onLat          : @(self.myPositionCoord.latitude),
                                     static_Argument_offGeogName    : self.offGeogName,
                                     static_Argument_offStationName : self.offStationName,
                                     static_Argument_offLng         : @(self.endPositionCoord.longitude),
                                     static_Argument_offLat         : @(self.endPositionCoord.latitude),
                                     static_Argument_vehTime        : self.startTime};
        [EBNetworkRequest POST:static_Url_Sponsor parameters:parameters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *code = dict[static_Argument_returnCode];
            if ([code integerValue] == 500) {
                [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [EBTool popToAttentionControllWithIndex:3 controller:self];
                });
            } else {
                [MBProgressHUD showError:@"发起失败" toView:self.view];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD showError:@"发起失败" toView:self.view];
        }];
    } else {
        [MBProgressHUD showError:@"参数配置错误" toView:self.view];
    }
}



@end





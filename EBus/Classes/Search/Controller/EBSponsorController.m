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
@interface EBSponsorController () <EBSearchBusViewDelegate>

@property (nonatomic, weak) EBSearchBusView *searchBusView;

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;
@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *onGeogName;
@property (nonatomic, copy) NSString *onStationName;
@property (nonatomic, copy) NSString *offGeogName;
@property (nonatomic, copy) NSString *offStationName;

@end

@implementation EBSponsorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起线路";
    self.view.backgroundColor = [UIColor whiteColor];
    self.myPositionCoord = kCLLocationCoordinate2DInvalid;
    self.endPositionCoord = kCLLocationCoordinate2DInvalid;
    [self searchBusViewImplementation];
}
- (void)searchBusViewImplementation {
    EBSearchBusView *searchBusView = [[EBSearchBusView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    searchBusView.showStartTimeBtn = YES;
    searchBusView.delegate = self;
    [self.view addSubview:searchBusView];
    self.searchBusView = searchBusView;
}
#pragma mark -EBSearchBusViewDelegate
- (void)searchBusView:(EBSearchBusView *)searchBusView clickType:(EBSearchBusClickType)type {
    switch (type) {
        case EBSearchBusClickTypeMyPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeEndPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeStartTime:
#warning 先写死，稍后自定义这个view
            self.startTime = @"0700";
            searchBusView.startTimeTitle = self.startTime;
            break;
        case EBSearchBusClickTypeDeleteOfMyPosition:
            self.myPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeDeleteOfEndPosition:
            self.endPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeDeleteOfStartTime:
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
            ws.onGeogName = district;
            ws.onStationName = title;
        } else if (type == EBSearchBusClickTypeEndPosition) {
            ws.searchBusView.endPositionTitle = title;
            ws.endPositionCoord = coord;
            ws.offGeogName = district;
            ws.offStationName = title;
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
            [MBProgressHUD showError:@"请填写起始地点" toView:self.view];
        } else if (!end) {
            [MBProgressHUD showError:@"请填写终点地点" toView:self.view];
        } else {
            [MBProgressHUD showError:@"请填写上车时间" toView:self.view];
        }
    }
}

- (void)sponsorRequest{
    
    if (self.onGeogName.length != 0 && self.onStationName.length != 0 && self.offGeogName.length != 0 && self.offStationName.length != 0) {
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
            NSString *code = dict[@"returnCode"];
            if ([code integerValue] == 500) {
                PHTabBarController *phTBC = (PHTabBarController *)self.tabBarController;
                phTBC.mySelectedIndex = 2;
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [MBProgressHUD showError:@"发起失败" toView:self.view];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD showError:@"发起失败" toView:self.view];
        }];
    }
}

@end





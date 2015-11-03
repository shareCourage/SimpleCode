//
//  EBBuyTicketController.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBuyTicketController.h"
#import "EBUsualLineCell.h"
#import "EBSearchResultModel.h"
#import "EBCalenderView.h"
#import "EBUserInfo.h"
#import "EBApplyBusController.h"
#import "EBPayTypeView.h"
#import "AppDelegate.h"
#import "EBOrderDetailModel.h"
#import "EBOrderDetailController.h"
@interface EBBuyTicketController () <EBCalenderViewDelegate, EBPayTypeViewDelegate>

@property (nonatomic, weak)EBCalenderView *calenderView;

@property (nonatomic, assign) CGFloat ticketPrice;

@property (nonatomic, weak) EBPayTypeView *payTypeView;

@property (nonatomic, strong) NSArray *dates;
@end

@implementation EBBuyTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购票";
    EBCalenderView *calenderView = [[EBCalenderView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
    calenderView.delegate = self;
//    calenderView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4f];
    self.tableView.tableFooterView = calenderView;
    self.calenderView = calenderView;
    [calenderView reloadData];
    
    [self networkRequest];
    [self payTypeViewImplementation];

}
- (void)payTypeViewImplementation {
    AppDelegate *delegate = EB_AppDelegate;
    EBPayTypeView *payView = [[EBPayTypeView alloc] initWithFrame:delegate.window.bounds];
    payView.hidden = YES;
    payView.delegate = self;
    NSArray *titles = @[@"支付宝",@"微信支付",@"深圳通",@"其它(老认证、军人证)"];
    NSArray *names = @[@"search_pay_zfb",@"search_pay_wechat",@"search_pay_szt",@"search_pay_other"];
    for (NSInteger i = 0; i < 4; i ++) {
        NSString *title = titles[i];
        NSString *name = names[i];
        [payView addTitleButtonWithTitle:title imageName:name];
    }
    [delegate.window addSubview:payView];
    self.payTypeView = payView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;;
}
#pragma mark - Request
- (void)networkRequest {
    NSString *beginStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.year,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.month,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.day];
    
    PHCalenderDay *calenderDay = [[EBUserInfo sharedEBUserInfo].daysInCurrentMonth lastObject];
    NSString *endStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                        (unsigned long)calenderDay.year,
                        (unsigned long)calenderDay.month,
                        (unsigned long)calenderDay.day];
    NSString *dayString = [NSString stringWithFormat:@"%@",@([EBUserInfo sharedEBUserInfo].currentCalendarDay.day)];
    for (NSUInteger i = [EBUserInfo sharedEBUserInfo].currentCalendarDay.day + 1; i <= calenderDay.day; i ++) {
        dayString = [dayString stringByAppendingString:@","];
        dayString = [dayString stringByAppendingString:[NSString stringWithFormat:@"%@",@(i)]];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.resultModel.lineId) {
        [parameters setObject:self.resultModel.lineId forKey:static_Argument_lineId];
    }
    if (self.resultModel.vehTime) {
        [parameters setObject:self.resultModel.vehTime forKey:static_Argument_vehTime];
    }
    if ([EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        [parameters setObject:[EBUserInfo sharedEBUserInfo].loginName forKey:static_Argument_customerName];
    }
    if ([EBUserInfo sharedEBUserInfo].loginId.length != 0) {
        [parameters setObject:[EBUserInfo sharedEBUserInfo].loginId forKey:static_Argument_customerId];
    }
    if (beginStr.length != 0) {
        [parameters setObject:beginStr forKey:static_Argument_beginDate];
    }
    if (endStr.length != 0) {
        [parameters setObject:endStr forKey:static_Argument_endDate];
    }
    
    [EBNetworkRequest GET:static_Url_SurplusTicket parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSDictionary *returnData = dict[static_Argument_returnData];
        NSString *price = returnData[@"prices"];
        self.ticketPrice = [price floatValue];
        NSMutableDictionary *mutD = [NSMutableDictionary dictionaryWithDictionary:returnData];
        [mutD setObject:dayString forKey:@"dayString"];
        self.calenderView.priceAndTicket = mutD;
        [self.calenderView reloadData];
    } errorBlock:nil];
}

- (void)payCash:(NSArray *)dates payType:(NSUInteger)type{
    [MBProgressHUD showMessage:nil toView:self.view];
    NSArray *sortArray = [dates sortedArrayUsingSelector:@selector(compare:)];//升序排序
    NSMutableArray *newDates = [NSMutableArray array];
    PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
    for (NSString *obj in sortArray) {
        NSString *string = [NSString stringWithFormat:@"%ld-%02ld-%02ld",currentDay.year, currentDay.month, [obj integerValue]];
        [newDates addObject:string];
    }
    NSString *newString = [EBTool stringConnected:newDates connectString:@","];
    EBLog(@"%@",newString);
    if (newString.length != 0 && self.resultModel.lineId && self.resultModel.vehTime && self.resultModel.startTime && self.resultModel.onStationId && self.resultModel.offStationId && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        NSDictionary *parameters = @{static_Argument_saleDates      : newString,
                                     static_Argument_lineId         : self.resultModel.lineId,
                                     static_Argument_vehTime        : self.resultModel.vehTime,
                                     static_Argument_startTime      : self.resultModel.startTime,
                                     static_Argument_onStationId    : self.resultModel.onStationId,
                                     static_Argument_offStationId   : self.resultModel.offStationId,
                                     static_Argument_tradePrice     : @(self.ticketPrice * dates.count),
                                     static_Argument_payType        : @(type),
                                     static_Argument_userId         : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_userName       : [EBUserInfo sharedEBUserInfo].loginName};
        [EBNetworkRequest GET:static_Url_Order parameters:parameters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString *string = dict[static_Argument_returnInfo];
            NSString *returCode = dict[static_Argument_returnCode];
            if ([returCode integerValue] != 500) {
                if ([string isEqualToString:@"深圳通卡号不可为空"]) {
                    [MBProgressHUD showError:@"还没绑定深圳通哦~" toView:self.view];
                } else if ([string isEqualToString:@"您没有免费证件支付的权限"]) {
                    [MBProgressHUD showError:@"您没有免费证件支付的权限" toView:self.view];
                } else {
                    [MBProgressHUD showError:string toView:self.view];
                }
            } else {
                NSDictionary *returnData = dict[static_Argument_returnData];
                NSDictionary *main = returnData[@"main"];
                if (main.count == 0) return;
                EBOrderDetailModel *orderModel = [[EBOrderDetailModel alloc] initWithDict:main];
                EBOrderDetailController *orderVC = [[EBOrderDetailController alloc] init];
                orderVC.orderModel = orderModel;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"购票失败" toView:self.view];
        }];
    }
    
}
#pragma mark - EBCalenderViewDelegate
- (void)eb_calenderView:(EBCalenderView *)calenderView didOrder:(NSArray *)dates {
    if (dates.count == 0) {
        [MBProgressHUD showError:@"请选择一个购票日期" toView:self.view];
    } else {
        self.payTypeView.hidden = NO;
        self.dates = [dates copy];
    }
}

- (void)eb_calenderViewDidApply:(EBCalenderView *)calenderView {
    EBApplyBusController *apply = [[EBApplyBusController alloc] init];
    [self.navigationController pushViewController:apply animated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
    cell.showBuyView = NO;
    cell.model = self.resultModel;
    return cell;
}

#pragma mark - EBPayTypeViewDelegate
- (void)payTypeView:(EBPayTypeView *)titleView didSelectIndex:(NSUInteger)index {
    if (index == 0) {
        [self payCash:self.dates payType:1];//支付宝支付
    } else if (index == 1) {
        [self payCash:self.dates payType:2];//微信支付
    } else if (index == 2) {
        [self payCash:self.dates payType:3];//深圳通支付
    } else if (index == 3) {
        [self payCash:self.dates payType:4];
    }
}


@end

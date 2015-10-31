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
@interface EBBuyTicketController () <EBCalenderViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak)EBCalenderView *calenderView;

@property (nonatomic, assign) CGFloat ticketPrice;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;;
}
#pragma mark - Request
- (void)networkRequest {
    NSString *beginStr = [NSString stringWithFormat:@"%ld%2ld%2ld",
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.year,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.month,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.day];
    
    PHCalenderDay *calenderDay = [[EBUserInfo sharedEBUserInfo].daysInCurrentMonth lastObject];
    NSString *endStr = [NSString stringWithFormat:@"%ld%2ld%2ld",
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
    NSArray *sortArray = [dates sortedArrayUsingSelector:@selector(compare:)];//升序排序
    NSMutableArray *newDates = [NSMutableArray array];
    PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
    for (NSString *obj in sortArray) {
        NSString *string = [NSString stringWithFormat:@"%ld-%2ld-%2ld",currentDay.year, currentDay.month, [obj integerValue]];
        [newDates addObject:string];
    }
    NSString *newString = [EBTool stringConnected:newDates connectString:@","];
    EBLog(@"%@",newString);
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
        EBLog(@"order -> %@",dict);
    } errorBlock:^(NSError *error) {
        
    }];
}
#pragma mark - EBCalenderViewDelegate
- (void)eb_calenderView:(EBCalenderView *)calenderView didOrder:(NSArray *)dates {
    if (dates.count == 0) {
        [MBProgressHUD showError:@"请选择一个购票日期" toView:self.view];
    } else {
#warning 需要自定义一个View
        [self payCash:dates payType:1];
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信",@"深圳通",@"其它(老认证、军人证)", nil];
//        [actionSheet showInView:self.view];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

}


@end

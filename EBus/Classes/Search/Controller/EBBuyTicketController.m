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
@interface EBBuyTicketController ()

@property (nonatomic, weak)EBCalenderView *calenderView;

@end

@implementation EBBuyTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购票";
    EBCalenderView *calenderView = [[EBCalenderView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
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
        [parameters setObject:self.resultModel.lineId forKey:static_Argument_vehTime];
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
#ifdef DEBUG
        returnData = @{@"prices":   @"2,2,2,2,2,2",
                       @"tickets":  @"40,40,-2,0,21,-2"};
#else
#endif
        NSMutableDictionary *mutD = [NSMutableDictionary dictionaryWithDictionary:returnData];
        [mutD setObject:dayString forKey:@"dayString"];
        self.calenderView.priceAndTicket = returnData;
        [self.calenderView reloadData];
    } errorBlock:nil];
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

@end

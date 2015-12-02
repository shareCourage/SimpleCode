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
#import "EBPayTool.h"
#import "EBSZTBookController.h"
#import "MobClick.h"
#import "EBOrderSpecificModel.h"
#import "EBFreeCertificateController.h"

@interface EBBuyTicketController () <EBCalenderViewDelegate, EBPayTypeViewDelegate>

@property (nonatomic, weak)EBCalenderView *eb_calenderView;
@property (nonatomic, weak) EBPayTypeView *payTypeView;

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) EBPayType payType;
@property (nonatomic, strong) NSArray *dates;

@end

@implementation EBBuyTicketController

- (void)setPayType:(EBPayType)payType {
    _payType = payType;
    [self payCash:self.dates payType:payType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购票";
    self.tableView.allowsSelection = NO;
    CGFloat calenderH = EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar;
    if (EB_HeightOfScreen <= 480) {
        calenderH = calenderH + 100;
    } else if (EB_HeightOfScreen <= 568) {
        calenderH = calenderH + 30;
    }
    EBCalenderView *calenderView = [[EBCalenderView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, calenderH)];
    calenderView.delegate = self;
    self.tableView.tableFooterView = calenderView;
    self.eb_calenderView = calenderView;
    
    [self payTypeViewImplementation];
    [MBProgressHUD showMessage:nil toView:self.view];
}

- (void)payTypeViewImplementation {
    AppDelegate *delegate = EB_AppDelegate;
    EBPayTypeView *payView = [[EBPayTypeView alloc] initWithFrame:delegate.window.bounds];
    payView.hidden = YES;
    payView.delegate = self;
    NSArray *titles = @[@"支付宝",@"微信支付",@"深圳通",@"其他(老人证、军人证)"];
    NSArray *names = @[@"search_pay_zfb",@"search_pay_wechat",@"search_pay_szt",@"search_pay_other"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        NSString *title = titles[i];
        NSString *name = names[i];
        [payView addTitleButtonWithTitle:title imageName:name];
    }
    [delegate.window addSubview:payView];
    self.payTypeView = payView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self calenderRequestOfCurrentMonth:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *returnData = dict[static_Argument_returnData];
        if (returnData.count != 0) {
            self.eb_calenderView.priceAndTicket = returnData;
        }
    }];
    [self calenderRequestOfNextMonth:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *returnData = dict[static_Argument_returnData];
        if (returnData.count != 0) {
            self.eb_calenderView.priceAndTicketNext = returnData;
        }
    }];
    self.dates = nil;
    self.totalPrice = 0.f;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;;
}
#pragma mark - Request
- (void)calenderRequestOfCurrentMonth:(EBOptionDict)optionDict {
    [EBUserInfo sharedEBUserInfo].currentDate = [NSDate date];
    NSString *beginStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.year,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.month,
                          (unsigned long)[EBUserInfo sharedEBUserInfo].currentCalendarDay.day];
    
    PHCalenderDay *calenderDay = [[EBUserInfo sharedEBUserInfo].daysInCurrentMonth lastObject];
    NSString *endStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                        (unsigned long)calenderDay.year,
                        (unsigned long)calenderDay.month,
                        (unsigned long)calenderDay.day];
    [self calenderNetworkRequestWithBegin:beginStr end:endStr dictBlock:optionDict];
}
- (void)calenderRequestOfNextMonth:(EBOptionDict)optionDict {
    if ([EBTool calenderScrollViewEnable]) {//能滑动下个月再有数据请求
        [EBUserInfo sharedEBUserInfo].currentDate = [[NSDate date] dayInTheFollowingMonth];
        PHCalenderDay *firstDay = [[EBUserInfo sharedEBUserInfo].daysInCurrentMonth firstObject];
        PHCalenderDay *lastDay = [[EBUserInfo sharedEBUserInfo].daysInCurrentMonth lastObject];
        NSString *beginStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                              (unsigned long)firstDay.year,
                              (unsigned long)firstDay.month,
                              (unsigned long)firstDay.day];
        NSString *endStr = [NSString stringWithFormat:@"%ld%02ld%02ld",
                            (unsigned long)lastDay.year,
                            (unsigned long)lastDay.month,
                            (unsigned long)lastDay.day];
        [self calenderNetworkRequestWithBegin:beginStr end:endStr dictBlock:optionDict];
    }
}

- (void)calenderNetworkRequestWithBegin:(NSString *)beginStr end:(NSString *)endStr dictBlock:(EBOptionDict)optionDict {
    
#if 0 //忘记这串代码干嘛用的，貌似没用处，先注释看看会不会有影响
    NSString *dayString = [NSString stringWithFormat:@"%@",@([EBUserInfo sharedEBUserInfo].currentCalendarDay.day)];
    for (NSUInteger i = [EBUserInfo sharedEBUserInfo].currentCalendarDay.day + 1; i <= calenderDay.day; i ++) {
        dayString = [dayString stringByAppendingString:@","];
        dayString = [dayString stringByAppendingString:[NSString stringWithFormat:@"%@",@(i)]];
    }
#endif
    
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
    
    [EBNetworkRequest GET:static_Url_SurplusTicket parameters:parameters dictBlock:optionDict errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 支付宝、微信支付
- (void)payCash:(NSArray *)dates payType:(EBPayType)type{
    if (dates.count == 0) return;
    [MobClick event:[NSString stringWithFormat:@"购票%@",NSStringFromSelector(_cmd)]];//友盟统计购票次数
    [MBProgressHUD showMessage:nil toView:self.view];
    NSUInteger payNumber = 0;
    switch (type) {
        case EBPayTypeOfAlipay:
            payNumber = 1;
            break;
        case EBPayTypeOfWeChat:
            payNumber = 2;
            break;
        case EBPayTypeOfSZT:
            payNumber = 3;
            break;
        case EBPayTypeOfOther:
            payNumber = 4;
            break;
        default:
            break;
    }
    NSString *newString = [EBTool stringConnected:dates connectString:@","];
    EBLog(@"%@",newString);
    if (newString.length != 0 && self.resultModel.lineId && self.resultModel.vehTime && self.resultModel.startTime && self.resultModel.onStationId && self.resultModel.offStationId && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        NSDictionary *parameters = @{static_Argument_saleDates      : newString,
                                     static_Argument_lineId         : self.resultModel.lineId,
                                     static_Argument_vehTime        : self.resultModel.vehTime,
                                     static_Argument_startTime      : self.resultModel.startTime,
                                     static_Argument_onStationId    : self.resultModel.onStationId,
                                     static_Argument_offStationId   : self.resultModel.offStationId,
                                     static_Argument_tradePrice     : @(self.totalPrice),
                                     static_Argument_payType        : @(payNumber),
                                     static_Argument_userId         : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_userName       : [EBUserInfo sharedEBUserInfo].loginName};
        [EBNetworkRequest GET:static_Url_Order parameters:parameters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString *string = dict[static_Argument_returnInfo];
            NSString *returCode = dict[static_Argument_returnCode];
            if ([returCode integerValue] != 500) {
                if ([string isEqualToString:@"深圳通卡号不可为空"]) {
                    [MBProgressHUD showError:@"深圳通卡号不能为空" toView:self.view];
                } else if ([string isEqualToString:@"您没有免费证件支付的权限"]) {
                    [MBProgressHUD showError:@"您没有免费证件支付的权限" toView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        EBFreeCertificateController *freeVC = [[EBFreeCertificateController alloc] init];
                        [self.navigationController pushViewController:freeVC animated:YES];
                    });
                } else {
                    [MBProgressHUD showError:string toView:self.view];
                }
            } else {
                NSDictionary *returnData = dict[static_Argument_returnData];
                NSDictionary *main = returnData[@"main"];
                if (main.count == 0) return;
                EBOrderDetailModel *orderModel = [[EBOrderDetailModel alloc] initWithDict:main];
                if (type == EBPayTypeOfAlipay || type == EBPayTypeOfWeChat) {
                    [self alipayOrWechatPay:type orderModel:orderModel];
                } else if (type == EBPayTypeOfOther){//使用免费证件支付成功后
                    [EBTool popToAttentionControllWithIndex:0 controller:self];
                }
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"购票失败" toView:self.view];
        }];
    }
    
}


- (void)alipayOrWechatPay:(EBPayType)type orderModel:(EBOrderDetailModel *)orderModel {
    EB_WS(ws);
    EBPayTool *payTool = [EBPayTool sharedEBPayTool];
    switch (type) {
        case EBPayTypeOfAlipay:
            if ([EBTool canOpenApplication:@"alipayShare://"]) {//判断是否安装了支付宝
                [payTool aliPayWithModel:orderModel completion:^(NSDictionary *dict) {
                    EBLog(@"%@->%@", NSStringFromSelector(_cmd),dict);
                    __strong typeof(self) strontSelf = ws;
                    NSNumber *status = dict[@"resultStatus"];
                    if ([status integerValue] == 9000) {//9000、支付成功 //6001、用户中途取消
                        [MBProgressHUD showSuccess:@"支付成功" toView:strontSelf.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [EBTool popToAttentionControllWithIndex:0 controller:strontSelf];
                        });
                    } else {
                        [MBProgressHUD showError:@"支付失败" toView:strontSelf.view];
                        [self pushToOrderDetailVCWithMode:orderModel];
                    }
                }];
            } else {
                [MBProgressHUD showError:@"手机未安装支付宝" toView:self.view];
                [self pushToOrderDetailVCWithMode:orderModel];
            }
            break;
        case EBPayTypeOfWeChat:
            if ([EBPayTool canPayByWeXin]) {
                [payTool wxPayWithModel:orderModel completion:^(NSDictionary *dict) {
                    NSString *string = dict[@"payResult"];
                    __strong typeof(self) strontSelf = ws;
                    if ([string isEqualToString:@"success"]) {
                        [MBProgressHUD showSuccess:@"支付成功" toView:strontSelf.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [EBTool popToAttentionControllWithIndex:0 controller:strontSelf];
                        });
                    } else if ([string isEqualToString:@"failure"]) {
                        [MBProgressHUD showError:@"支付失败" toView:strontSelf.view];
                        [self pushToOrderDetailVCWithMode:orderModel];
                    }
                }];
            } else {
                [MBProgressHUD showError:@"手机未安装微信" toView:self.view];
                [self pushToOrderDetailVCWithMode:orderModel];
            }
            break;
        default:
            break;
    }
}

- (void)pushToOrderDetailVCWithMode:(EBOrderDetailModel *)orderModel {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        EBOrderDetailController *orderVC = [[EBOrderDetailController alloc] init];
        if (orderModel.ID && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length) {
            [MBProgressHUD showMessage:nil toView:self.view];
            NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                         static_Argument_userId   : [EBUserInfo sharedEBUserInfo].loginId,
                                         static_Argument_id       : orderModel.ID};
            [EBNetworkRequest GET:static_Url_OrderDetail parameters:parameters dictBlock:^(NSDictionary *dict) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSNumber *code = dict[static_Argument_returnCode];
                if ([code integerValue] != 500) {
                    [MBProgressHUD showError:@"获取信息失败" toView:self.view];
                    return;
                }
                NSDictionary *data = dict[static_Argument_returnData];
                EBOrderSpecificModel *specific = [[EBOrderSpecificModel alloc] initWithDict:data];
                orderVC.specificModel = specific;
                [self.navigationController pushViewController:orderVC animated:YES];
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"获取信息失败" toView:self.view];
            }];
            
        }
    });
}


#pragma mark - EBCalenderViewDelegate
- (void)eb_calenderView:(EBCalenderView *)calenderView didOrder:(NSArray *)dates totalPrice:(CGFloat)price{
    self.totalPrice = price;
    if (dates.count == 0) {
        [MBProgressHUD showError:@"还没有选择需要购票的日期" toView:self.view];
    } else {
        self.payTypeView.hidden = NO;
        self.dates = [dates copy];
    }
}

- (void)eb_calenderViewDidApply:(EBCalenderView *)calenderView {
    EBApplyBusController *apply = [[EBApplyBusController alloc] init];
    apply.resultModel = self.resultModel;
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
        self.payType = EBPayTypeOfAlipay;
    } else if (index == 1) {
        self.payType = EBPayTypeOfWeChat;
    } else if (index == 2) {
        EBSZTBookController *book = [[EBSZTBookController alloc] init];
        book.dates = [self.dates copy];
        book.resultModel = self.resultModel;
        book.totalPrice = self.totalPrice;
        [self.navigationController pushViewController:book animated:YES];
    } else if (index == 3) {
        self.payType = EBPayTypeOfOther;
    }
}


@end

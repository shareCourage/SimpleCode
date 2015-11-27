//
//  EBOrderDetailController.m
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderDetailController.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"
#import "EBBaseLineCell.h"
#import "EBOrderDetailModel.h"
#import "EBOrderStatusView.h"
#import "EBPayTypeView.h"
#import "EBUserInfo.h"
#import "EBPayTool.h"
#import "EBMyOrderModel.h"
#import "EBBuyTicketController.h"
#import "EBRefundController.h"
#import "EBOrderSpecificModel.h"
#import "EBSecondList.h"

@interface EBOrderDetailController () <UITableViewDataSource, UITableViewDelegate, EBPayTypeViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) EBOrderStatusView *orderStatusView;
@property (nonatomic, weak) EBPayTypeView *payTypeView;
@property (nonatomic, weak) EBBaseLineCell *baseCell;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong)UIAlertView *alertView;
@property(nonatomic, strong)UIAlertView *alertViewCanFromMyOrder;

@end

@implementation EBOrderDetailController

#pragma mark - 懒加载
- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}
- (UIAlertView *)alertViewCanFromMyOrder {
    if (!_alertViewCanFromMyOrder) {
        _alertViewCanFromMyOrder = [[UIAlertView alloc] initWithTitle:@"确定退票？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertViewCanFromMyOrder;
}

#pragma mark - 重写setter , getter方法
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setSpecificModel:(EBOrderSpecificModel *)specificModel {
    _specificModel = specificModel;
    if (specificModel.secondList.count != 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:specificModel.secondList];
    }
    self.orderStatusView.specificModel = specificModel;
    self.baseCell.model = specificModel;
}

#pragma mark - Override Super Method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    [self payTypeViewImplementation];
    [self cellImplementation];
    [self tableViewImplementation];
    [self bottomViewImplementation];
}

#pragma mark - Implementation
- (void)payTypeViewImplementation {
    AppDelegate *delegate = EB_AppDelegate;
    EBPayTypeView *payView = [[EBPayTypeView alloc] initWithFrame:delegate.window.bounds];
    payView.hidden = YES;
    payView.delegate = self;
    NSArray *titles = @[@"支付宝",@"微信支付"];
    NSArray *names = @[@"search_pay_zfb",@"search_pay_wechat"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        NSString *title = titles[i];
        NSString *name = names[i];
        [payView addTitleButtonWithTitle:title imageName:name];
    }
    [delegate.window addSubview:payView];
    self.payTypeView = payView;
}

- (void)cellImplementation {
    CGRect cellF = CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, 100);
    EBBaseLineCell *cell = [[EBBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.frame = cellF;
    cell.model = self.specificModel;
    [self.view addSubview:cell];
    self.baseCell = cell;
}

- (void)tableViewImplementation {
    CGFloat height = (EB_HeightOfScreen > 480) ? 200 : 130;
    CGRect tvF = CGRectMake(0, EB_HeightOfNavigationBar + 100, EB_WidthOfScreen, height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF];
    tableView.backgroundColor = EB_RGBColor(246, 246, 246);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)bottomViewImplementation {
    EB_WS(ws);
    UIView *infoV = [[UIView alloc] init];
    [self.view addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.tableView.mas_bottom).with.offset(0);
        make.bottom.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(0);
        make.right.equalTo(ws.view).with.offset(0);
    }];
    self.bottomView = infoV;

    
    CGFloat bvH = 50;
    UIView *btnView = [[UIView alloc] init];
    [infoV addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoV).with.offset(-10);
        make.left.equalTo(infoV).with.offset(0);
        make.right.equalTo(infoV).with.offset(0);
        make.height.mas_equalTo(bvH);
    }];
    
    [self displayDifferentBtn:btnView height:bvH];
#if 0
    if (self.canFromMyOrder && [self.specificModel.status integerValue] == 0) {//未支付状态
        NSArray *sales = [self.specificModel.saleDates componentsSeparatedByString:@","];
        NSString *runDate = [sales firstObject];
        NSString *startTime = self.specificModel.startTime;
#if DEBUG
//        runDate = @"2015-11-23";
//        startTime = @"14:55";
#endif
        if ([EBTool isTimeOutWithDate:runDate startTime:startTime]) {
            [self bottomHaveTwoButtonImplentation:btnView height:bvH];//生成支付、取消订单按钮
        } else {
            [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
        }

    } else if (self.canFromMyOrder && [self.specificModel.status integerValue] == 2) {//已支付状态
        NSArray *sales = [self.specificModel.saleDates componentsSeparatedByString:@","];
        NSString *runDate = [sales firstObject];
        NSString *startTime = self.specificModel.startTime;
#if DEBUG
//        runDate = @"2015-11-23";
//        startTime = @"14:55";
#endif
        if ([EBTool isTimeOutWithDate:runDate startTime:startTime]) {
            NSArray *titles = @[@"退票", @"续订"];
            [self bottomViewTwoButton:titles selector:@selector(orderAgainClick:) btnView:btnView height:bvH];//生成续订button + 退款按钮
        } else {
            [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
        }
        
    } else if (self.canFromMyOrder) {
        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
    } else {
        [self bottomHaveTwoButtonImplentation:btnView height:bvH];
    }
#endif
    
    EBOrderStatusView *orderV = [EBOrderStatusView orderStatusViewFromXib];
    orderV.orderModel = self.specificModel;
    [infoV addSubview:orderV];
    [orderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoV).with.offset(0);
        make.bottom.equalTo(btnView.mas_top).with.offset(0);
        make.left.equalTo(infoV).with.offset(0);
        make.right.equalTo(infoV).with.offset(0);
    }];
    self.orderStatusView = orderV;
}

#if 0 //这串代码用来测试
- (void)eb_displayDifferentBtn:(UIView *)btnView height:(CGFloat)bvH {
    if (self.canFromMyOrder) {//来自我的订单页面cell的点击
        NSArray *secondLists = self.specificModel.secondList;
        BOOL manyDates = NO;
        if (secondLists.count > 1) {
            manyDates = YES;
        }
        EBSecondList *seclMF = [secondLists firstObject];
        NSInteger payStatus = [self.specificModel.status integerValue];//支付状态
        NSInteger payType = [self.specificModel.payType integerValue];
        if (payType == 1 || payType == 2) {//微信或者支付宝支付
            if (payStatus == 0) {//未支付
                
            } else if (payStatus == 2) {//已经支付
                
            } else if (payStatus == 3 || payStatus == 1 || payStatus == 4) {//已退票,已取消,退款中
                [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
            }
        } else if (payType == 3 || payType == 4) {//深圳通或者免费证件支付
            if (payStatus == 0) {//未支付
                
            } else if (payStatus == 2) {//已经支付
                
            } else if (payStatus == 3 || payStatus == 1 || payStatus == 4) {//已退票,已取消,退款中
                [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
            }
        }
    } else {//来自购票页面不成功时候的跳转
        [self bottomHaveTwoButtonImplentation:btnView height:bvH];
    }
}
#endif
/*
 *逻辑太复杂，我自己都无奈了
 1、对支付方式要判断；
 2、对是否支付、是否取消、是否退票要判断
 2、对多日期要判断
 3、多日期对是否全部日期过期要判断
 4、单日期对是否过期要判断
 */
- (void)displayDifferentBtn:(UIView *)btnView height:(CGFloat)bvH {
    if (self.canFromMyOrder) {//来自我的订单页面cell的点击
        NSArray *sales = [self.specificModel.saleDates componentsSeparatedByString:@","];
        if (sales.count == 0) {//如果没有日期，那就不需要进行判断了
            [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
            return;
        }
        BOOL manyDates = NO;
        if (sales.count > 1) {
            manyDates = YES;
        }
        NSArray *sortArray = [sales sortedArrayUsingSelector:@selector(compare:)];//升序排序
        NSString *runDate = [sortArray firstObject];
        NSString *startTime = self.specificModel.startTime;
        NSInteger payStatus = [self.specificModel.status integerValue];//支付状态
        NSInteger payType = [self.specificModel.payType integerValue];
        if (payType == 1 || payType == 2) {//微信或者支付宝支付
            if (payStatus == 0) {//未支付
                if (manyDates) {//有很多天
                    BOOL value = [EBTool allOutDate:sales startTime:startTime];
                    if (value) {//全部都过期了
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    } else{
                        NSArray *titles = @[@"取消订单", @"续订"];
                        [self bottomViewTwoButton:titles selector:@selector(cancelOrderAndAgain:) btnView:btnView height:bvH];//@"取消订单", @"续订"
                    }
                } else {
                    if ([EBTool isWaitingWithDate:runDate startTime:startTime]) {
                        [self bottomHaveTwoButtonImplentation:btnView height:bvH];//生成支付、取消订单按钮
                    } else {
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    }
                }
            } else if (payStatus == 2) {//已经支付
                if (manyDates) {//有很多天
                    BOOL value = [EBTool allOutDate:sales startTime:startTime];
                    if (value) {//全部都过期了
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    } else { //找到未过期的那张票，然后判断他的状态如何
                        NSArray *secondLists = self.specificModel.secondList;
                        NSInteger index = 0;
                        for (EBSecondList *seclM in secondLists) {
                            if ([EBTool isWaitingWithDate:seclM.runDate startTime:seclM.startTime]) break;
                            index ++;
                        }
                        EBSecondList *seclM = secondLists[index];
                        if ([seclM.status integerValue] == 2) {
                            NSArray *titles = @[@"退票", @"续订"];
                            [self bottomViewTwoButton:titles selector:@selector(orderAgainClick:) btnView:btnView height:bvH];//生成续订button + 退款按钮
                        } else {
                            [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                        }
                    }
                } else {//只有一天
                    if ([EBTool isWaitingWithDate:runDate startTime:startTime]) {
                        NSArray *titles = @[@"退票", @"续订"];
                        [self bottomViewTwoButton:titles selector:@selector(orderAgainClick:) btnView:btnView height:bvH];//生成续订button + 退款按钮
                    } else {
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    }
                }
            } else if (payStatus == 3 || payStatus == 1 || payStatus == 4) {//已退票,已取消,退款中
                [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
            }
        } else if (payType == 3 || payType == 4) {//深圳通或者免费证件支付
            if (payStatus == 0) {//未支付
                if (manyDates) {//有很多天
                    BOOL value = [EBTool allOutDate:sales startTime:startTime];
                    if (value) {//全部都过期了
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    } else {
                        NSArray *titles = @[@"取消订单", @"续订"];
                        [self bottomViewTwoButton:titles selector:@selector(cancelOrderAndAgain:) btnView:btnView height:bvH];//@"取消订单", @"续订"
                    }
                } else {//只有一天
                    if ([EBTool isWaitingWithDate:runDate startTime:startTime]) {
                        NSArray *titles = @[@"取消订单", @"续订"];
                        [self bottomViewTwoButton:titles selector:@selector(cancelOrderAndAgain:) btnView:btnView height:bvH];//@"取消订单", @"续订"
                    } else {
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    }
                }
            } else if (payStatus == 2) {//已经支付
                if (manyDates) {//有很多天
                    BOOL value = [EBTool allOutDate:sales startTime:startTime];
                    if (value) {//全部都过期了
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    } else {//找到未过期的那张票，然后判断他的状态如何
                        NSArray *secondLists = self.specificModel.secondList;
                        NSInteger index = 0;
                        for (EBSecondList *seclM in secondLists) {
                            if ([EBTool isWaitingWithDate:seclM.runDate startTime:seclM.startTime]) break;
                            index ++;
                        }
                        EBSecondList *seclM = secondLists[index];
                        if ([seclM.status integerValue] == 2) {
                            NSArray *titles = @[@"退票", @"续订"];
                            [self bottomViewTwoButton:titles selector:@selector(orderAgainClick:) btnView:btnView height:bvH];//生成续订button + 退款按钮
                        } else {
                            [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                        }
                    }
                } else {//只有一天
                    if ([EBTool isWaitingWithDate:runDate startTime:startTime]) {
                        NSArray *titles = @[@"退票", @"续订"];
                        [self bottomViewTwoButton:titles selector:@selector(orderAgainClick:) btnView:btnView height:bvH];//生成续订button + 退款按钮
                    } else {
                        [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
                    }
                }
                
            } else if (payStatus == 3 || payStatus == 1 || payStatus == 4) {//已退票,已取消,退款中
                [self bottomHaveOneButtonImplentation:btnView height:bvH];//生成续订button
            }
        }
    } else {//来自购票页面不成功时候的跳转
        [self bottomHaveTwoButtonImplentation:btnView height:bvH];
    }
}

- (void)bottomHaveOneButtonImplentation:(UIView *)btnView height:(CGFloat)height{
    CGFloat padding = 20;
    UIButton *orderAgainBtn = [UIButton eb_buttonWithFrame:CGRectZero target:self action:@selector(orderAgainClick:) Title:@"续订"];
    orderAgainBtn.tag = 1;//这个tag一定要设置
    orderAgainBtn.layer.cornerRadius = height / 2;
    [btnView addSubview:orderAgainBtn];
    [orderAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView).with.offset(0);
        make.bottom.equalTo(btnView).with.offset(0);
        make.left.equalTo(btnView).with.offset(padding);
        make.right.equalTo(btnView).with.offset(-padding);
    }];
}

- (void)bottomHaveTwoButtonImplentation:(UIView *)btnView height:(CGFloat)bvH{
    NSArray *btnTitles = @[@"支付",@"取消订单"];
    [self bottomViewTwoButton:btnTitles selector:@selector(payClick:) btnView:btnView height:bvH];
}
- (void)bottomViewTwoButton:(NSArray *)btnTitles selector:(SEL)selector btnView:(UIView *)btnView height:(CGFloat)bvH {
    NSUInteger count = btnTitles.count;
    for (NSUInteger i = 0; i < count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.layer.cornerRadius = bvH / 2;
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:EB_DefaultColor];
        CGFloat padding = 10;
        CGFloat hhhh = padding * 3;//边距
        CGFloat bW = (EB_WidthOfScreen - hhhh * 2 - (count - 1) * padding) / count;
        CGFloat bX = hhhh + i * (bW + padding);
        CGFloat bY = 0;
        CGFloat bH = bvH;
        CGRect btnF = CGRectMake(bX, bY, bW, bH);
        btn.frame = btnF;
        [btnView addSubview:btn];
    }
}



#pragma mark - Target Method
//取消订单、续订按钮
- (void)cancelOrderAndAgain:(UIButton *)sender {
    if (sender.tag == 0) {
        [self eb_CancelOrder];
    } else if (sender.tag == 1) {
        [self eb_buyAgain];
    }
}

//退票、续订按钮
- (void)orderAgainClick:(UIButton *)sender {
    if (sender.tag == 0) {//退票
        [self eb_pushToRefundVC];
    } else if (sender.tag == 1) {//续订
        [self eb_buyAgain];
    }
}

//支付、取消订单按钮
- (void)payClick:(UIButton *)sender {
    if (sender.tag == 0) {//支付
        self.payTypeView.hidden = NO;
    } else if (sender.tag == 1) {//取消订单
        [self eb_CancelOrder];
    }
}

- (void)eb_pushToRefundVC {
    EBRefundController *refund = [[EBRefundController alloc] init];
    refund.specificModel = self.specificModel;
    [self.navigationController pushViewController:refund animated:YES];
}

- (void)eb_buyAgain {
    EBBuyTicketController *buy = [[EBBuyTicketController alloc] init];
    buy.resultModel = [EBSearchResultModel resultModelFromOrderDetailModel:self.specificModel];
    [self.navigationController pushViewController:buy animated:YES];
}

- (void)eb_CancelOrder {
    if (EB_iOS(8.0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[self actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[self actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self cancelOrder];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (EB_iOS(5.0)) {
        [self.alertView show];
    }
}

- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"EBOrderDetailControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.contentView.backgroundColor = EB_RGBColor(246, 246, 246);
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"乘车日期";
        cell.detailTextLabel.text = @"状态";
    } else {
        EBSecondList *secondList = self.dataSource[indexPath.row - 1];
        cell.textLabel.text = secondList.runDate;
        NSInteger status = [secondList.status integerValue];
        cell.detailTextLabel.text = [EBTool stringFromStatus:status];//将数字转化为为文字
    }
    return cell;
}

#pragma mark - EBPayTypeViewDelegate
- (void)payTypeView:(EBPayTypeView *)titleView didSelectIndex:(NSUInteger)index {
    if (index == 0) {//点击了支付宝支付
        if ([self.specificModel.payType integerValue] == 1) {//如果之前的支付方式是支付宝，那么不需要更改支付方式
            //这里直接进行支付宝支付
            [self alipayOrWechatPay:EBPayTypeOfAlipay orderModel:self.specificModel];
        } else if ([self.specificModel.payType integerValue] == 2) {//之前是微信支付，先更改为支付宝支付
            //更改支付方式为支付宝支付
            [MBProgressHUD showMessage:nil toView:self.view];
            [self changePayTypeTo:EBPayTypeOfAlipay success:^(NSDictionary *dict) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *code = dict[static_Argument_returnCode];
                EBLog(@"returnInfo -> %@  %@", dict[static_Argument_returnInfo], code);
                if ([code integerValue] == 500) {
                    self.specificModel.payType = @(1);//将原始数据model的支付方式也进行更改为支付宝支付
                    self.orderStatusView.orderModel = self.specificModel;
                    [self alipayOrWechatPay:EBPayTypeOfAlipay orderModel:self.specificModel];
                } else {
                    [MBProgressHUD showError:@"更改支付方式失败" toView:self.view];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showError:@"更改支付方式失败" toView:self.view];
            }];
        }
    } else if (index == 1) {//点击了微信支付
        if ([self.specificModel.payType integerValue] == 1) {//判断之前的支付方式是不是微信支付
            //更改支付方式为微信支付
            [MBProgressHUD showMessage:nil toView:self.view];
            [self changePayTypeTo:EBPayTypeOfWeChat success:^(NSDictionary *dict) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *code = dict[static_Argument_returnCode];
                EBLog(@"returnInfo -> %@  %@", dict[static_Argument_returnInfo], code);
                if ([code integerValue] == 500) {
                    self.specificModel.payType = @(2);//将原始数据model的支付方式也进行更改为微信支付
                    self.orderStatusView.orderModel = self.specificModel;
                    [self alipayOrWechatPay:EBPayTypeOfWeChat orderModel:self.specificModel];
                } else {
                    [MBProgressHUD showError:@"更改支付方式失败" toView:self.view];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showError:@"更改支付方式失败" toView:self.view];
            }];
        } else if ([self.specificModel.payType integerValue] == 2) {
            //这里直接进行微信支付
            [self alipayOrWechatPay:EBPayTypeOfWeChat orderModel:self.specificModel];
        }
    } 
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.alertView) {
        if (buttonIndex == 1) {
            [self cancelOrder];
        }
    } else if (alertView == self.alertViewCanFromMyOrder) {
        if (buttonIndex == 1) {
            [self eb_pushToRefundVC];
        }
    }
}

#pragma mark - Network
- (void)cancelOrder {
    if (self.specificModel.ID && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        NSDictionary *parameters = @{static_Argument_id : self.specificModel.ID,
                                     static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId};
        [EBNetworkRequest GET:static_Url_CancelOrder parameters:parameters
                    dictBlock:^(NSDictionary *dict) {
                        NSString *code = dict[static_Argument_returnCode];
                        if ([code integerValue] == 500) {
                            [MBProgressHUD showSuccess:@"取消订单成功" toView:self.view];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        } else {
                            [MBProgressHUD showError:@"取消失败"];
                        }
                    } errorBlock:^(NSError *error) {
                        [MBProgressHUD showError:@"取消失败"];
                    }];
    }
}


#pragma mark - pay
- (void)alipayOrWechatPay:(EBPayType)type orderModel:(EBOrderDetailModel *)orderModel {
    EB_WS(ws);
    EBPayTool *payTool = [EBPayTool sharedEBPayTool];
    switch (type) {
        case EBPayTypeOfAlipay:
            if ([EBTool canOpenApplication:@"alipayShare://"]) {//判断是否安装了支付宝
                [payTool aliPayWithModel:orderModel completion:^(NSDictionary *dict) {
                    EBLog(@"%@->%@", NSStringFromSelector(_cmd),dict);
                    __strong typeof(self) strontSelf = ws;
                    NSNumber *status = dict[static_Argument_resultStatus];
                    if ([status integerValue] == 9000) {//9000、支付成功 //6001、用户中途取消
                        [MBProgressHUD showSuccess:@"支付成功" toView:strontSelf.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [EBTool popToAttentionControllWithIndex:0 controller:strontSelf];
                        });
                    } else {
                        [MBProgressHUD showError:@"支付失败" toView:strontSelf.view];
                    }
                }];
            } else {
                [MBProgressHUD showError:@"手机未安装支付宝" toView:self.view];
            }
            break;
        case EBPayTypeOfWeChat:
            if ([EBPayTool canPayByWeXin]) {
                [payTool wxPayWithModel:orderModel completion:^(NSDictionary *dict) {
                    NSString *string = dict[static_Argument_payResult];
                    __strong typeof(self) strontSelf = ws;
                    if ([string isEqualToString:@"success"]) {
                        [MBProgressHUD showSuccess:@"支付成功" toView:strontSelf.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [EBTool popToAttentionControllWithIndex:0 controller:strontSelf];
                        });
                    } else if ([string isEqualToString:@"failure"]) {
                        [MBProgressHUD showError:@"支付失败" toView:strontSelf.view];
                    }
                }];
            } else {
                [MBProgressHUD showError:@"手机未安装微信" toView:self.view];
            }
            break;
        default:
            break;
    }
}
#pragma mark - Change Pay Type
- (void)changePayTypeTo:(EBPayType)to success:(EBOptionDict)dictB failure:(EBOptionError)errorB {
    if (!self.specificModel.ID) return;//如果没有支付单号，结束操作
    NSNumber *payType = nil;
    if (to == EBPayTypeOfAlipay) {
        payType = @(1);
    } else if (to == EBPayTypeOfWeChat) {
        payType = @(2);
    } else if (to == EBPayTypeOfSZT) {
        payType = @(3);
    } else {
        return;
    }
    NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_payType : payType,
                                 static_Argument_id : self.specificModel.ID};
    [EBNetworkRequest POST:static_Url_ChangePayType parameters:parameters dictBlock:dictB errorBlock:errorB];
}
@end

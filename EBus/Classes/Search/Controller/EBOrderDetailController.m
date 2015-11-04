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
@interface EBOrderDetailController () <UITableViewDataSource, UITableViewDelegate, EBPayTypeViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) EBPayTypeView *payTypeView;


@property(nonatomic, strong)UIAlertView *alertView;

@end

@implementation EBOrderDetailController
- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setOrderModel:(EBOrderDetailModel *)orderModel {
    _orderModel = orderModel;
    if (orderModel.saleDates.length != 0) {
        NSArray *sales = [orderModel.saleDates componentsSeparatedByString:@","];
        [self.dataSource addObjectsFromArray:sales];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    [self payTypeViewImplementation];
    [self cellImplementation];
    [self tableViewImplementation];
    [self bottomViewImplementation];
}
- (void)payTypeViewImplementation {
    AppDelegate *delegate = EB_AppDelegate;
    EBPayTypeView *payView = [[EBPayTypeView alloc] initWithFrame:delegate.window.bounds];
    payView.hidden = YES;
    payView.delegate = self;
    NSArray *titles = @[@"支付宝",@"微信支付",@"其它(老认证、军人证)"];
    NSArray *names = @[@"search_pay_zfb",@"search_pay_wechat",@"search_pay_other"];
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
    cell.model = self.orderModel;
    [self.view addSubview:cell];
}

- (void)tableViewImplementation {
    CGRect tvF = CGRectMake(0, EB_HeightOfNavigationBar + 100, EB_WidthOfScreen, 200);
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
    

    CGFloat bvH = 50;
    UIView *btnView = [[UIView alloc] init];
    [infoV addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoV).with.offset(-10);
        make.left.equalTo(infoV).with.offset(0);
        make.right.equalTo(infoV).with.offset(0);
        make.height.mas_equalTo(bvH);
    }];
    NSArray *btnTitles = @[@"支付",@"取消订单"];
    NSUInteger count = btnTitles.count;
    for (NSUInteger i = 0; i < count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    EBOrderStatusView *orderV = [EBOrderStatusView orderStatusViewFromXib];
    orderV.orderModel = self.orderModel;
    [infoV addSubview:orderV];
    [orderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoV).with.offset(0);
        make.bottom.equalTo(btnView.mas_top).with.offset(0);
        make.left.equalTo(infoV).with.offset(0);
        make.right.equalTo(infoV).with.offset(0);
    }];
}

- (void)payClick:(UIButton *)sender {
    if (sender.tag == 0) {
        self.payTypeView.hidden = NO;
    } else if (sender.tag == 1) {
        if (EB_iOS(8.0)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[self actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[self actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self cancelOrder];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (EB_iOS(6.0)) {
            [self.alertView show];
        }
    }
}
- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
}
#pragma mark - UITableView

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
        cell.textLabel.text = self.dataSource[indexPath.row - 1];
        if ([self.orderModel.status integerValue] == 0) {
            cell.detailTextLabel.text = @"未支付";
        } else {
            cell.detailTextLabel.text = @"已支付";
        }
    }
    return cell;
}

#pragma mark - EBPayTypeViewDelegate
- (void)payTypeView:(EBPayTypeView *)titleView didSelectIndex:(NSUInteger)index {
    if (index == 0) {
        
    } else if (index == 1) {
        
    } else if (index == 2) {
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.alertView) {
        if (buttonIndex == 1) {
            [self cancelOrder];
        }
    }
}

#pragma mark - Network
- (void)cancelOrder {
    if (self.orderModel.ID && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        NSDictionary *parameters = @{static_Argument_id : self.orderModel.ID,
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
@end

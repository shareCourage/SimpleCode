//
//  EBMeSettingController.m
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMeSettingController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
#import "EBUserInfo.h"

#import "EBMoreViewController.h"
#import "EBMyOrderListController.h"
#import "EBSuggestController.h"
#import "EBSZTBookController.h"
#import "EBFreeCertificateController.h"

#import "APService.h"


@interface EBMeSettingController () <UIAlertViewDelegate>
{
    BOOL _hasLogin;
}
@property(nonatomic, strong)UIAlertView *alertView;
@property (nonatomic, weak) UIView *footerView;
@end

@implementation EBMeSettingController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 懒加载
- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"确定注销?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}

#pragma mark - super
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    [self headerViewImplementation];
    [self initImplementation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCenter) name:EBLoginSuccessNotification object:nil];

}
#pragma mark - Implementation
- (void)initImplementation {
    if ([EBUserInfo sharedEBUserInfo].loginName.length != 0 && [EBUserInfo sharedEBUserInfo].loginId.length != 0) {
        _hasLogin = YES;
    }
    [self footerViewImplementation];
    [self one];
}

- (void)headerViewImplementation {
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, 100)];
    headerImageView.image = [UIImage imageNamed:@"me_header"];
    self.tableView.tableHeaderView = headerImageView;
}

- (void)footerViewImplementation {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    if (_hasLogin) {
        UILabel *idLabel = [[UILabel alloc] init];
        idLabel.center = footerView.center;
        idLabel.bounds = CGRectMake(0, 0, 280, 30);
        idLabel.textAlignment = NSTextAlignmentCenter;
        idLabel.text = [NSString stringWithFormat:@"ID: %@",[EBUserInfo sharedEBUserInfo].loginName];
        [footerView addSubview:idLabel];
    } else {
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat loginH = 40;
        loginBtn.center = footerView.center;
        loginBtn.bounds = CGRectMake(0, 0, 280, loginH);
        loginBtn.layer.cornerRadius = loginH / 2;
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTintColor:[UIColor whiteColor]];
        [loginBtn setBackgroundColor:EB_DefaultColor];
        [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:loginBtn];
    }
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
}

- (void)one
{
    PHSettingItem *ticket = [PHSettingArrowItem itemWithTitle:@"我的订单" destVcClass:nil];
    EB_WS(ws);
    ticket.option = ^{
        __strong typeof(self) strongSelf = ws;
        if (![EBTool presentLoginVC:strongSelf completion:nil]) {
            EBMyOrderListController *orderList = [[EBMyOrderListController alloc] init];
            [strongSelf.navigationController pushViewController:orderList animated:YES];
        }
    };
    PHSettingItem *notification = [PHSettingArrowItem itemWithTitle:@"我的通知" destVcClass:nil];
    notification.option = ^{
        __strong typeof(self) strongSelf = ws;
        if (![EBTool presentLoginVC:strongSelf completion:nil]) {
            EBLog(@"我的通知");
        }
    };
    PHSettingItem *szt = [PHSettingArrowItem itemWithTitle:@"深圳通卡" destVcClass:nil];
    szt.option = ^{
        __strong typeof(self) strongSelf = ws;
        if (![EBTool presentLoginVC:strongSelf completion:nil]) {
            EBSZTBookController *sztVC = [[EBSZTBookController alloc] init];
            sztVC.myTitle = @"深圳通";
            sztVC.hidenBookBtn = YES;
            [strongSelf.navigationController pushViewController:sztVC animated:YES];
        }
    };
    PHSettingItem *freeCertificate = [PHSettingArrowItem itemWithTitle:@"免费证件" destVcClass:nil];
    freeCertificate.option = ^{
        __strong typeof(self) strongSelf = ws;
        if (![EBTool presentLoginVC:strongSelf completion:nil]) {
            EBFreeCertificateController *freeCert = [[EBFreeCertificateController alloc] init];
            [strongSelf.navigationController pushViewController:freeCert animated:YES];
        }
    };
    
    PHSettingItem *advice = [PHSettingArrowItem itemWithTitle:@"投诉建议"];
    advice.option = ^{
        __strong typeof(self) strongSelf = ws;
        if (![EBTool presentLoginVC:strongSelf completion:nil]) {
            EBSuggestController *suggest = [[EBSuggestController alloc] init];
            [strongSelf.navigationController pushViewController:suggest animated:YES];
        }
    };
//    PHSettingItem *versionUpdate = [PHSettingArrowItem itemWithTitle:@"版本更新" destVcClass:nil];
    PHSettingItem *more = [PHSettingArrowItem itemWithTitle:@"更多" destVcClass:[EBMoreViewController class]];
    PHSettingItem *logout = [PHSettingArrowItem itemWithTitle:@"注销"];
    logout.option = ^{
        [ws.alertView show];
    };
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    if (_hasLogin) {
//        group.items = @[ticket,notification,szt,freeCertificate,advice,versionUpdate,more,logout];
//        group.items = @[ticket,notification,szt,freeCertificate,advice,more,logout];
        group.items = @[ticket,szt,freeCertificate,advice,more,logout];
    } else {
//        group.items = @[ticket,notification,szt,freeCertificate,advice,versionUpdate,more];
//        group.items = @[ticket,notification,szt,freeCertificate,advice,more];
        group.items = @[ticket,szt,freeCertificate,advice,more];
    }
    [self.dataSource addObject:group];
}
#pragma mark - Private Method
- (void)loginClick {
    [EBTool presentLoginVC:self completion:nil];
}

- (void)loginCenter {
    _hasLogin = NO;
    [self.dataSource removeAllObjects];
    [self.footerView removeFromSuperview];
    [self initImplementation];
    [self.tableView reloadData];
    [self APServiceTagsAndAliasSetUp];
    [EBTool openAppInitial];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (EB_WidthOfScreen <= 320) ? 44 : 50;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.alertView) {
        if (buttonIndex == 1) {
            [EBUserInfo sharedEBUserInfo].loginName = nil;
            [EBUserInfo sharedEBUserInfo].loginId = nil;
            [EBUserInfo sharedEBUserInfo].sztNo = nil;
            [self loginCenter];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:EBLogoutSuccessNotification object:self];
                [self APServiceTagsAndAliasSetUp];
            });
        }
    }
}

- (void)APServiceTagsAndAliasSetUp {
    NSSet *tags = nil;
    NSString *alias = nil;
    if ([EBTool loginEnable]) {
        tags = [[NSSet alloc] initWithObjects:@"ebus", nil];
        alias = [NSString stringWithFormat:@"ebus_%@",[EBUserInfo sharedEBUserInfo].loginId];
    } else {
        tags = [[NSSet alloc] initWithObjects:@"nologin", nil];
        alias = @"";
    }
    [APService setTags:tags alias:alias callbackSelector:nil object:nil];
}
@end









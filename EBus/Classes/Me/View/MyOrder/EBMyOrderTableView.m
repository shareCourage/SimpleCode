//
//  EBMyOrderTableView.m
//  EBus
//
//  Created by Kowloon on 15/11/10.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "EBUserInfo.h"
#import "EBMyOrderCompletedModel.h"
#import "EBMyOrderUncompletedModel.h"
#import "EBMyOrderCell.h"
#import "EBMyOrderHeaderView.h"

@interface EBMyOrderTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation EBMyOrderTableView

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Super
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        EB_WS(ws);
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws tableViewRefresh];
        }];
        self.tableView = tableView;
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.contentMode = UIViewContentModeCenter;
        UIImage *image = [UIImage imageNamed:@"main_background"];
        backgroundImageView.image = image;
        tableView.backgroundView = backgroundImageView;
        self.backgroundImageView = backgroundImageView;
    }
    return self;
}
- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

#pragma mark - Public Method
- (void)beginRefresh {
    [self.tableView.header beginRefreshing];
    self.refresh = YES;
}

#pragma mark - Private Method
- (void)tableViewRefresh {
    [self myOrderRequestAndTableViewReloadData];
}

- (void)myOrderRequestAndTableViewReloadData {
    if (self.tag == EBMyOrderTypeOfCompleted) {
        [self completedRequest];
    } else if (self.tag == EBMyOrderTypeOfUncompleted) {
        [self uncompletedRequest];
    }
}

- (void)completedRequest {
    NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_payStatus : @(2)};
    [self myOrderRequest:parameters success:^(NSDictionary *dict) {
        [self.tableView.header endRefreshing];
        EBLog(@"%@",dict);
        NSArray *data = dict[static_Argument_returnData];
        [self.dataSource removeAllObjects];
        for (NSDictionary *obj in data) {
            EBMyOrderModel *myOrderModel = [[EBMyOrderCompletedModel alloc] initWithDict:obj];
            [self.dataSource addObject:myOrderModel];;
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)uncompletedRequest {
    NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_payStatus : @(1)};
    [self myOrderRequest:parameters success:^(NSDictionary *dict) {
        [self.tableView.header endRefreshing];
        NSArray *data = dict[static_Argument_returnData];
        [self.dataSource removeAllObjects];
        for (NSDictionary *obj in data) {
            EBMyOrderModel *myOrderModel = [[EBMyOrderUncompletedModel alloc] initWithDict:obj];
            [self.dataSource addObject:myOrderModel];;
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - Request
- (void)myOrderRequest:(id)parameters success:(EBOptionDict)dictBlock failure:(EBOptionError)errorBlock{
    if (!parameters) return;
    [EBNetworkRequest GET:static_Url_MyOrder parameters:parameters dictBlock:dictBlock errorBlock:errorBlock indicatorVisible:NO];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EBMyOrderHeaderView *headerView = [EBMyOrderHeaderView headerViewWithTableView:tableView];
    headerView.orderModel = self.dataSource[section];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBMyOrderCell *cell = [EBMyOrderCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EBMyOrderModel *orderModel = self.dataSource[indexPath.section];
    if ([self.delegate respondsToSelector:@selector(mo_tableView:didSelect:)]) {
        [self.delegate mo_tableView:self didSelect:orderModel];
    }
    if (self.tag == EBMyOrderTypeOfCompleted) {
        EBMyOrderCompletedModel *orderModelCompleted = (EBMyOrderCompletedModel *)orderModel;
        if ([self.delegate respondsToSelector:@selector(mo_tableView:didSelectOfTypeCompleted:)]) {
            [self.delegate mo_tableView:self didSelectOfTypeCompleted:orderModelCompleted];
        }
    } else if (self.tag == EBMyOrderTypeOfUncompleted) {
        EBMyOrderUncompletedModel *orderModelUn = (EBMyOrderUncompletedModel *)orderModel;
        if ([self.delegate respondsToSelector:@selector(mo_tableView:didSelectOfTypeUnCompleted:)]) {
            [self.delegate mo_tableView:self didSelectOfTypeUnCompleted:orderModelUn];
        }
    }
}

@end






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
{
    NSUInteger _pageNumber;
}
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
        _pageNumber = 1;
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        EB_WS(ws);
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageNumber = 1;
            [ws xl_tableViewRefresh];
        }];
        tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            [ws sl_tableViewRefresh];
        }];
        tableView.footer.hidden = YES;
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
- (void)myOrderTableViewDidAppear {
    _pageNumber = 1;
    [self xl_tableViewRefresh];
    [self.tableView scrollsToTop];
}

- (void)myOrderTableViewDidDisAppear {
    
}
#pragma mark - Private Method
- (void)xl_tableViewRefresh {//下拉刷新
    [self myOrderRequest:[self parametersOfRefresh] success:^(NSDictionary *dict) {
        [self.tableView.header endRefreshing];
        EBLog(@"%@",dict);
        NSArray *data = dict[static_Argument_returnData];
        [self.dataSource removeAllObjects];
        for (NSDictionary *obj in data) {
            if (self.tag == EBMyOrderTypeOfCompleted) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderCompletedModel alloc] initWithDict:obj];
                [self.dataSource addObject:myOrderModel];
            } else if (self.tag == EBMyOrderTypeOfUncompleted) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderUncompletedModel alloc] initWithDict:obj];
                [self.dataSource addObject:myOrderModel];
            }
        }
        if (self.dataSource.count == 0) {
            self.tableView.footer.hidden = YES;
            self.backgroundImageView.hidden = NO;
        } else {
            if (self.dataSource.count >= EB_pageSize) {
                self.tableView.footer.hidden = NO;
            }
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)sl_tableViewRefresh {//上拉刷新
    [self myOrderRequest:[self parametersOfRefresh] success:^(NSDictionary *dict) {
        [self.tableView.footer endRefreshing];
        NSArray *data = dict[static_Argument_returnData];
        EBLog(@"%@, %ld",dict, (unsigned long)data.count);
        if (data.count == 0) {
            return;
        }
        for (NSDictionary *obj in data) {
            if (self.tag == EBMyOrderTypeOfCompleted) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderCompletedModel alloc] initWithDict:obj];
                [self.dataSource addObject:myOrderModel];
            } else if (self.tag == EBMyOrderTypeOfUncompleted) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderUncompletedModel alloc] initWithDict:obj];
                [self.dataSource addObject:myOrderModel];
            }
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];

}

- (NSDictionary *)parametersOfRefresh {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([EBUserInfo sharedEBUserInfo].loginName) {
        [parameters setObject:[EBUserInfo sharedEBUserInfo].loginName forKey:static_Argument_userName];
    }
    if ([EBUserInfo sharedEBUserInfo].loginId) {
        [parameters setObject:[EBUserInfo sharedEBUserInfo].loginId forKey:static_Argument_userId];
    }
    NSNumber *payStatus = nil;
    if (self.tag == EBMyOrderTypeOfCompleted) {
        payStatus = @(2);
    } else if (self.tag == EBMyOrderTypeOfUncompleted) {
        payStatus = @(1);
    }
    [parameters setObject:payStatus forKey:static_Argument_payStatus];
    [parameters setObject:@(_pageNumber) forKey:static_Argument_pageNo];
    [parameters setObject:@(EB_pageSize) forKey:static_Argument_pageSize];

    return parameters;
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






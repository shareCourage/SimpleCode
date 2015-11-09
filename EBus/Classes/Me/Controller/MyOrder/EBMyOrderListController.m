//
//  EBMyOrderListController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderListController.h"
#import <MJRefresh/MJRefresh.h>
#import "EBUserInfo.h"
#import "EBMyOrderCompletedModel.h"
#import "EBMyOrderUncompletedModel.h"
#import "EBMyOrderCell.h"

typedef  NS_ENUM(NSUInteger, EBMyOrderType) {
    EBMyOrderTypeOfCompleted = 1000,
    EBMyOrderTypeOfUncompleted,
};

@interface EBMyOrderListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceCompleted;
@property (nonatomic, strong) NSMutableArray *dataSourceUnCompleted;
@property (nonatomic, assign) EBMyOrderType orderType;

@property (nonatomic, weak) UISegmentedControl *segControl;
@property (nonatomic, weak) UIScrollView *tableScrollView;
@property (nonatomic, weak) UITableView *tableViewCompleted;
@property (nonatomic, weak) UITableView *tableViewUnCompleted;
@property (nonatomic, weak) UIImageView *backgroundImageView;

@end

@implementation EBMyOrderListController
- (NSMutableArray *)dataSourceCompleted {
    if (!_dataSourceCompleted) {
        _dataSourceCompleted = [NSMutableArray array];
    }
    return _dataSourceCompleted;
}

- (NSMutableArray *)dataSourceUnCompleted {
    if (!_dataSourceUnCompleted) {
        _dataSourceUnCompleted = [NSMutableArray array];
    }
    return _dataSourceUnCompleted;
}

- (void)setOrderType:(EBMyOrderType)orderType {
    _orderType = orderType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self segmentImplementation];
    [self scrollViewImplementation];
}





- (void)tableViewRefresh {
    NSNumber *payStatus = nil;
    if (self.orderType == EBMyOrderTypeOfCompleted) {
        payStatus = @(2);
    } else if (self.orderType == EBMyOrderTypeOfUncompleted) {
        payStatus = @(1);
    }
    NSDictionary *parameters = @{static_Argument_userName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_payStatus : payStatus};
    if (self.orderType == EBMyOrderTypeOfCompleted) {
        [self myOrderRequest:parameters success:^(NSDictionary *dict) {
            [self.tableViewCompleted.header endRefreshing];
            NSArray *data = dict[static_Argument_returnData];
            if (data.count == 0) return;
            [self.dataSourceCompleted removeAllObjects];
            for (NSDictionary *obj in data) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderCompletedModel alloc] initWithDict:obj];
                [self.dataSourceCompleted addObject:myOrderModel];;
            }
            [self.tableViewCompleted reloadData];
            
        } failure:^(NSError *error) {
            [self.tableViewCompleted.header endRefreshing];
        }];
    } else if (self.orderType == EBMyOrderTypeOfUncompleted) {
        [self myOrderRequest:parameters success:^(NSDictionary *dict) {
            [self.tableViewUnCompleted.header endRefreshing];
            NSArray *data = dict[static_Argument_returnData];
            if (data.count == 0) return;
            [self.dataSourceUnCompleted removeAllObjects];
            for (NSDictionary *obj in data) {
                EBMyOrderModel *myOrderModel = [[EBMyOrderUncompletedModel alloc] initWithDict:obj];
                [self.dataSourceUnCompleted addObject:myOrderModel];;
            }
            [self.tableViewUnCompleted reloadData];
            
        } failure:^(NSError *error) {
            [self.tableViewUnCompleted.header endRefreshing];
        }];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewCompleted) {
        return self.dataSourceCompleted.count;
    } else if (tableView == self.tableViewUnCompleted) {
        return self.dataSourceUnCompleted.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EBMyOrderCell cellWithTableView:tableView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / EB_WidthOfScreen;
    self.segControl.selectedSegmentIndex = index;
}

#pragma mark - Request
- (void)myOrderRequest:(id)parameters success:(EBOptionDict)dictBlock failure:(EBOptionError)errorBlock{
    if (!parameters) return;
    [EBNetworkRequest GET:static_Url_MyOrder parameters:parameters dictBlock:dictBlock errorBlock:errorBlock];
}


#pragma mark - Implementation
- (void)segmentImplementation {
    NSArray *titles = @[@"已完成", @"未完成"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:titles];
    seg.tintColor = EB_DefaultColor;
    seg.layer.borderColor = [UIColor whiteColor].CGColor;
    seg.layer.borderWidth = 2.f;
    seg.layer.cornerRadius = 5;
    seg.selectedSegmentIndex = 0;
    [self segClick:seg];
    seg.backgroundColor = [UIColor whiteColor];
    seg.frame = CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, 40);
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    self.segControl = seg;
    
}
- (void)scrollViewImplementation {
    CGFloat scrollX = 0;
    CGFloat scrollY = EB_HeightOfNavigationBar + 40;
    CGFloat scrollW = EB_WidthOfScreen;
    CGFloat scrollH = EB_HeightOfScreen - scrollY;
    CGRect scrollF = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollF];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(EB_WidthOfScreen * 2, scrollH);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    for (NSUInteger i = 0; i < 2 ; i ++) {
        CGFloat tableX = i * EB_WidthOfScreen;
        CGFloat tableY = 0;
        CGFloat tableW = EB_WidthOfScreen;
        CGFloat tableH = scrollH;
        CGRect tableF = CGRectMake(tableX, tableY, tableW, tableH);
        UITableView *tableView = [self tableViewImplementation];
        tableView.frame = tableF;
        tableView.delegate = self;
        [scrollView addSubview:tableView];
        if (i == 0) self.tableViewCompleted = tableView;
        if (i == 1) self.tableViewUnCompleted = tableView;
    }
    [self.view addSubview:scrollView];
    self.tableScrollView = scrollView;
}

- (UITableView *)tableViewImplementation {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    EB_WS(ws);
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws tableViewRefresh];
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.contentMode = UIViewContentModeCenter;
    UIImage *image = [UIImage imageNamed:@"main_background"];
    backgroundImageView.image = image;
    tableView.backgroundView = backgroundImageView;
    self.backgroundImageView = backgroundImageView;
    [self.view addSubview:tableView];
    return tableView;
}
#pragma mark - Target
- (void)segClick:(UISegmentedControl *)sender {
    CGPoint offset = CGPointMake(sender.selectedSegmentIndex * EB_WidthOfScreen, 0);
    [self.tableScrollView setContentOffset:offset animated:YES];
    if (sender.selectedSegmentIndex == 0) {
        self.orderType = EBMyOrderTypeOfCompleted;
    } else if (sender.selectedSegmentIndex == 1) {
        self.orderType = EBMyOrderTypeOfUncompleted;
    }
}
@end

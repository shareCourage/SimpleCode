//
//  EBMyOrderListController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderListController.h"
#import "EBMyOrderTableView.h"
#import "EBMyOrderModel.h"
#import "EBOrderDetailController.h"
@interface EBMyOrderListController () <UIScrollViewDelegate, EBMyOrderTableViewDelegate>

@property (nonatomic, weak) UISegmentedControl *segControl;
@property (nonatomic, weak) UIScrollView *tableScrollView;
@property (nonatomic, strong) NSMutableArray *tableViews;

@end

@implementation EBMyOrderListController
- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self segmentImplementation];
    [self scrollViewImplementation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    for (EBMyOrderTableView *tableView in self.tableViews) {
//        [tableView myOrderRequestAndTableViewReloadData];
//    }
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
        EBMyOrderTableView *myTableView = [[EBMyOrderTableView alloc] initWithFrame:tableF];
        myTableView.delegate = self;
        myTableView.tag = EBMyOrderTypeOfCompleted + i;
        [scrollView addSubview:myTableView];
        [self.tableViews addObject:myTableView];
        if (i == 0) {
            [myTableView beginRefresh];
        }
    }
    [self.view addSubview:scrollView];
    self.tableScrollView = scrollView;
}

#pragma mark - Target
- (void)segClick:(UISegmentedControl *)sender {
    CGPoint offset = CGPointMake(sender.selectedSegmentIndex * EB_WidthOfScreen, 0);
    [self.tableScrollView setContentOffset:offset animated:YES];
    [self tableViewReloadData:sender.selectedSegmentIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / EB_WidthOfScreen;
    self.segControl.selectedSegmentIndex = index;
    [self tableViewReloadData:index];
}

- (void)tableViewReloadData:(NSUInteger)index {
    if (index >= self.tableViews.count) return;
    EBMyOrderTableView *tableView = self.tableViews[index];
    if (!tableView.isRefreshed) {
        [tableView beginRefresh];
    }
}
#pragma mark - EBMyOrderTableViewDelegate
- (void)mo_tableView:(EBMyOrderTableView *)tableView didSelect:(EBMyOrderModel *)orderModel {
    EBLog(@"%@",orderModel.mainNo);
    EBOrderDetailController *orderDetailVC = [[EBOrderDetailController alloc] init];
    orderDetailVC.orderModel = orderModel;
    orderDetailVC.canFromMyOrder = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
@end







//
//  EBAttentionController.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_HeightOfAttentionTitleView 50
#import "EBAttentionController.h"
#import "EBAttentionTitleView.h"
#import "EBAttentionTableView.h"
#import "EBUserInfo.h"
#import "EBSearchResultModel.h"
#import "EBBoughtModel.h"
#import "EBSignModel.h"
#import "EBGroupModel.h"
#import "EBLineDetailController.h"
@interface EBAttentionController () <EBAttentionTitleViewDelegate, EBAttentionTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) EBAttentionTitleView *titleView;
@property (nonatomic, weak) UIScrollView *tableScrollView;

@property (nonatomic, strong) NSMutableArray *tableViews;
@end

@implementation EBAttentionController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (void)setTitleSelectIndex:(NSUInteger)titleSelectIndex {
    _titleSelectIndex = titleSelectIndex;
    [self.titleView selectIndex:titleSelectIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    [self titleViewImplementation];
    [self scrollViewImplementation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotificationCenter) name:EBLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationCenter) name:EBLoginSuccessNotification object:nil];
}

- (void)logoutNotificationCenter {
    for (EBAttentionTableView *tableView in self.tableViews) {
        [tableView attentionRequestAndTableViewReloadData];
        tableView.refresh = NO;
    }
}

- (void)loginNotificationCenter {
    EBAttentionTableView *tableView = [self.tableViews firstObject];
    [tableView attentionRequestAndTableViewReloadData];
    tableView.refresh = YES;
}

- (void)scrollViewImplementation {
    CGFloat scrollX = 0;
    CGFloat scrollY = EB_HeightOfNavigationBar + EB_HeightOfAttentionTitleView;
    CGFloat scrollW = EB_WidthOfScreen;
    CGFloat scrollH = EB_HeightOfScreen - scrollY - EB_HeightOfTabBar;
    CGRect scrollF = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollF];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(EB_WidthOfScreen * 4, scrollH);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    for (NSUInteger i = 0; i < 4 ; i ++) {
        CGFloat tableX = i * EB_WidthOfScreen;
        CGFloat tableY = 0;
        CGFloat tableW = EB_WidthOfScreen;
        CGFloat tableH = scrollH;
        CGRect tableF = CGRectMake(tableX, tableY, tableW, tableH);
        EBAttentionTableView *tableView = [[EBAttentionTableView alloc] initWithFrame:tableF];
        tableView.delegate = self;
        tableView.tag = i + EBAttentionTypePurchase;
        [scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        if (i == 0) {
            if ([EBTool loginEnable]) {
                [tableView beginRefresh];
            }
        }
    }
    [self.view addSubview:scrollView];
    self.tableScrollView = scrollView;
    
//    self.tableScrollView.contentOffset = CGPointMake(self.titleSelectIndex * scrollW, scrollH);
}

- (void)titleViewImplementation {
    EBAttentionTitleView *titleView = [[EBAttentionTitleView alloc] initWithFrame:CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, EB_HeightOfAttentionTitleView)];
    titleView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    titleView.layer.borderWidth = 1.f;
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    NSArray *titleImages = @[@"Attention_buy",@"Attention_register",@"Attention_group",@"Attention_sponsor"];
    NSArray *titleImagesSel = @[@"Attention_buyHL",@"Attention_registerHL",@"Attention_groupHL",@"Attention_sponsorHL"];
    // 2.添加对应个数的按钮
    for (int i = 0; i < 4; i++) {
        NSString *name = titleImages[i];
        NSString *selName = titleImagesSel[i];
        [titleView addTitleButtonWithName:name selName:selName];
    }
    [titleView selectIndex:self.titleSelectIndex];
}

- (void)tableViewReloadData:(NSUInteger)index {
    if (index >= self.tableViews.count) return;
    EBAttentionTableView *tableView = self.tableViews[index];
    if (!tableView.isRefreshed) {
        if ([EBTool loginEnable]) {
            [tableView beginRefresh];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / EB_WidthOfScreen;
    [self.titleView selectIndex:index];
    [self tableViewReloadData:index];
}

#pragma mark - EBAttentionTitleViewDelegate
- (void)titleView:(EBAttentionTitleView *)titleView didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to {
    EBLog(@"from %ld , to %ld",(unsigned long)from, (unsigned long)to);
    [self.tableScrollView setContentOffset:CGPointMake(to * EB_WidthOfScreen, 0) animated:YES];
    [self tableViewReloadData:to];
}

#pragma mark - EBAttentionTableViewDelegate
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypePurchase:(EBBoughtModel *)bough {
    [self pushToLineDetailController:[self searchResultModel:bough]];
}

- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypeSign:(EBSignModel *)sign {
    [self pushToLineDetailController:[self searchResultModel:sign]];

}
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypeGroup:(EBGroupModel *)group {
    [self pushToLineDetailController:[self searchResultModel:group]];
}

#pragma mark - Private Method
- (EBSearchResultModel *)searchResultModel:(EBBaseModel *)model {
    EBSearchResultModel *resultM = [[EBSearchResultModel alloc] init];
    if ([model isKindOfClass:[EBBoughtModel class]]) {
        EBBoughtModel *bought = (EBBoughtModel *)model;
        resultM.lineId = bought.lineId;
        resultM.openType = @(1);
        resultM.startTime = bought.startTime;
        resultM.mileage = bought.mileage;
        resultM.needTime = bought.needTime;
        resultM.onStationName = bought.onStationName;
        resultM.offStationName = bought.offStationName;
        resultM.price = bought.price;
        resultM.onStationId = bought.onStationId;
        resultM.offStationId = bought.offStationId;
        resultM.startTime = bought.startTime;
        resultM.vehTime = bought.vehTime;
    } else if ([model isKindOfClass:[EBSignModel class]] || [model isKindOfClass:[EBGroupModel class]]) {
        EBAttentionModel *attention = (EBAttentionModel *)model;
        resultM.lineId = attention.lineId;
        resultM.startTime = attention.startTime;
        resultM.mileage = attention.mileage;
        resultM.needTime = attention.needTime;
        resultM.onStationName = attention.onStationName;
        resultM.offStationName = attention.offStationName;
        resultM.onStationId = attention.onStationId;
        resultM.offStationId = attention.offStationId;
        resultM.startTime = attention.startTime;
        resultM.vehTime = attention.vehTime;
        if ([model isKindOfClass:[EBSignModel class]]) {
            EBSignModel *sign = (EBSignModel *)model;
            resultM.price = sign.price;
            resultM.openType = @(2);
        } else if ([model isKindOfClass:[EBGroupModel class]]) {
            resultM.openType = @(3);
        }
    }
    
    return resultM;
}


- (void)pushToLineDetailController:(EBSearchResultModel *)resultModel {
    EBLineDetailController *lineDetail = [[EBLineDetailController alloc] init];
    lineDetail.resultModel = resultModel;
    [self.navigationController pushViewController:lineDetail animated:YES];
}
@end







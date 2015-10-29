//
//  EBSearchResultController.m
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchResultController.h"

#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

#import "EBLineDetailController.h"
#import "EBUsualLineCell.h"
#import "EBSearchResultModel.h"
#import "EBHotLabel.h"

#import "EBSponsorController.h"

@interface EBSearchResultController () <EBUsualLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation EBSearchResultController
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索结果";
    EB_WS(ws);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refresh];
    }];
    [self.tableView.header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self bottomViewImplementation];
    self.backgroundImageViewAppear = NO;
}

#pragma mark  - Implementation
- (void)bottomViewImplementation {
    CGFloat bottomH = 60;
//    CGFloat bottomY = EB_HeightOfScreen - bottomH - 64;
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, bottomH)];
    bottom.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//    [self.view addSubview:bottom];
    self.tableView.tableFooterView = bottom;
    
    UIButton *programe = [UIButton buttonWithType:UIButtonTypeCustom];
    [programe setTitle:@"我来规划线路" forState:UIControlStateNormal];
    programe.titleLabel.font = [UIFont systemFontOfSize:20];
    [programe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [programe setBackgroundColor:EB_RGBColor(157, 197, 236)];
    programe.layer.cornerRadius = 25;
    [programe addTarget:self action:@selector(programeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:programe];
    CGFloat padding = 5;
    [programe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom).with.offset(padding);
        make.bottom.equalTo(bottom).with.offset(-padding);
        make.left.equalTo(bottom).with.offset(padding * 6);
        make.right.equalTo(bottom).with.offset(- padding * 6);
    }];
}

- (void)programeBtnClick {
    if (![EBTool presentLoginVC:self completion:nil]) {
        EBSponsorController *sponsor = [[EBSponsorController alloc] init];
        [self.navigationController pushViewController:sponsor animated:YES];
    }
}

- (void)refresh {
    NSDictionary *parameters = nil;
    NSString *url = nil;
    if (self.hotLabel) {
        parameters = @{static_Argument_labelId : self.hotLabel.labelId};
        url = static_Url_SearchBus_Label;
    } else {
        url = static_Url_SearchBus;
        if (CLLocationCoordinate2DIsValid(self.myPositionCoord) && CLLocationCoordinate2DIsValid(self.endPositionCoord)) {//如果两个经纬度都有效
            NSString *onlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.myPositionCoord.longitude,self.myPositionCoord.latitude];
            NSString *offlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.endPositionCoord.longitude,self.endPositionCoord.latitude];
            parameters = @{static_Argument_onLngLat : onlnglat,
                           static_Argument_offLngLat: offlnglat};
        } else if (CLLocationCoordinate2DIsValid(self.myPositionCoord)) {//我的位置经纬度有效
            NSString *onlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.myPositionCoord.longitude,self.myPositionCoord.latitude];
            parameters = @{static_Argument_onLngLat : onlnglat};
        } else if (CLLocationCoordinate2DIsValid(self.endPositionCoord)) {//终点经纬度有效
            NSString *offlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.endPositionCoord.longitude,self.endPositionCoord.latitude];
            parameters = @{static_Argument_offLngLat: offlnglat};
        } else {//两个经纬度均无效
            return;
        }
    }
    [EBNetworkRequest GET:url parameters:parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"\n %@",dict);
        [self.tableView.header endRefreshing];
        NSArray *returnData = dict[static_Argument_returnData];
        if (returnData.count == 0) return;
        [self.dataSource removeAllObjects];
        for (NSDictionary *dict in returnData) {
            EBSearchResultModel *model = [[EBSearchResultModel alloc] initWithDict:dict];
            [self.dataSource addObject:model];
        }
        self.backgroundImageViewAppear = YES;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    } indicatorVisible:NO];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
    cell.delegate = self;
    EBSearchResultModel *result = self.dataSource[indexPath.row];
    cell.model = result;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EBSearchResultModel *result = self.dataSource[indexPath.row];
    [self pushToLineDetailController:result];
}

#pragma mark - EBUsualLineCellDelegate

- (void)usualLineDidClick:(EBUsualLineCell *)usualLine type:(EBSearchBuyType)type{
    switch (type) {
        case EBSearchBuyTypeOfBuy:
            EBLog(@"EBSearchBuyTypeOfBuy");
            break;
        case EBSearchBuyTypeOfGroup:
            EBLog(@"EBSearchBuyTypeOfGroup");
            break;
        case EBSearchBuyTypeOfSign:
            EBLog(@"EBSearchBuyTypeOfSign");
            break;
        default:
            break;
    }
}

- (void)pushToLineDetailController:(EBSearchResultModel *)model {
    EBLineDetailController *detail = [[EBLineDetailController alloc] init];
    detail.resultModel = model;
    [self.navigationController pushViewController:detail animated:YES];
}

@end




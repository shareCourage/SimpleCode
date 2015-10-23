//
//  EBSearchResultController.m
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchResultController.h"
#import <MJRefresh/MJRefresh.h>
#import "EBLineDetailController.h"
#import "EBUsualLineCell.h"
#import "EBSearchResultModel.h"

@interface EBSearchResultController () <EBUsualLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) UIButton *programeBtn;
@property (nonatomic, weak) NSString *filePath;
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
#ifdef DEBUG
    EBSearchResultModel *result = [[EBSearchResultModel alloc] init];
    result.openType = @1;
    result.lineId = @1;
    result.startTime = @"0700";
    [self.dataSource addObject:result];
    [self.tableView reloadData];
#else
    EB_WS(ws);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refresh];
    }];
    
    [self.tableView.header beginRefreshing];
#endif
    
    [self tableViewFooterButtonImplementation];
    
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.filePath = [documents stringByAppendingPathComponent:@"searchResult.arc"];
}

- (void)tableViewFooterButtonImplementation {
    UIButton *programe = [UIButton buttonWithType:UIButtonTypeCustom];
    programe.hidden = YES;
    programe.frame = CGRectMake(0, 0, 200, 50);
    [programe setTitle:@"我来规划线路" forState:UIControlStateNormal];
    [programe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [programe addTarget:self action:@selector(programeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    programe.layer.cornerRadius = 25;
    [programe setBackgroundColor:EB_RGBColor(157, 197, 236)];
    self.tableView.tableFooterView = programe;
    self.programeBtn = programe;
}

- (void)programeBtnClick {
    
}

- (void)refresh {
    
#ifdef DEBUG
    self.dataSource = [EBTool decoderObjectPath:self.filePath];
    if (self.dataSource.count != 0) return;
    NSString *onlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.myPositionCoord.longitude,self.myPositionCoord.latitude];
    NSDictionary *parameters = @{static_Argument_onLngLat : onlnglat};
#else
    NSString *onlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.myPositionCoord.longitude,self.myPositionCoord.latitude];
    NSString *offlnglat = [NSString stringWithFormat:@"%.6f,%.6f",self.endPositionCoord.longitude,self.endPositionCoord.latitude];
    NSDictionary *parameters = @{static_Argument_onLngLat : onlnglat,
                                 static_Argument_offLngLat: offlnglat};
#endif
    
    
    [EBNetworkRequest GET:static_Url_SearchBus parameters:parameters dictBlock:^(NSDictionary *dict) {
        EBLog(@"\n %@",dict);
        [self.dataSource removeAllObjects];
        NSArray *returnData = dict[@"returnData"];
        for (NSDictionary *dict in returnData) {
            EBSearchResultModel *model = [[EBSearchResultModel alloc] initWithDict:dict];
            [self.dataSource addObject:model];
#ifdef DEBUG
            [EBTool encoderObjectArray:self.dataSource path:self.filePath];
#else
#endif
        }
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        self.programeBtn.hidden = NO;
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




//
//  EBTransferController.m
//  EBus
//
//  Created by Kowloon on 15/11/6.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferController.h"
#import <MJRefresh/MJRefresh.h>
#import "EBLineMapView.h"
#import "EBTransferLineCell.h"
#import "EBSearchResultModel.h"
#import "EBLineDetailModel.h"
#import "EBTransferModel.h"
#import "EBUserInfo.h"
#import "EBTicketViewController.h"

@interface EBTransferController () <EBLineMapViewDelegate, EBTransferLineCellDelegate>

@property(nonatomic, strong) NSString *filePath;//文件路径
@property (nonatomic, strong) EBSearchResultModel *resultModel;
@property (nonatomic, strong) EBTransferModel *transferModel;

@property (nonatomic, assign) BOOL tableViewAppear;
@property (nonatomic, weak) UIView *footerView;
@property (nonatomic, weak) EBLineMapView *lineMapView;
@end

@implementation EBTransferController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    EBLog(@"%@ --> dealloc", NSStringFromClass([self class]));
}

- (void)setTableViewAppear:(BOOL)tableViewAppear {
    _tableViewAppear = tableViewAppear;
    if (tableViewAppear) {
        self.footerView.hidden = NO;
        self.lineMapView.hidden = NO;
        self.backgroundImageViewDisappear = YES;
    } else {
        self.footerView.hidden = YES;
        self.lineMapView.hidden = YES;
        self.backgroundImageViewDisappear = NO;
    }
}

- (void)setResultModel:(EBSearchResultModel *)resultModel {
    _resultModel = resultModel;
    self.lineMapView.resultModel = resultModel;
    [self lineDetailRequest];
}

- (NSString *)filePath {
    if (!_filePath) {
        if (!self.resultModel.lineId) return nil;
        NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lineId.arc",self.resultModel.lineId]];
    }
    return _filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"乘车";
    self.tableViewAppear = NO;
    [EBUserInfo sharedEBUserInfo].singletonMapView = NO;
    [self footerViewImplementation];
    [EBUserInfo sharedEBUserInfo].singletonMapView = YES;//保证这个mapView是单独实例化的，而不是从单例中拿的
    EB_WS(ws);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshWithLoading:NO];
    }];
    self.tableView.allowsSelection = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:EBLogoutSuccessNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lineMapView mapViewDidAppear];
    if ([EBTool loginEnable]) {
        [self refreshWithLoading:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.lineMapView mapViewDidDisappear];
}

- (void)logoutNotification {
    self.tableViewAppear = NO;
    [self.tableView reloadData];
}
- (void)footerViewImplementation {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar - EB_HeightOfTabBar - 30)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    EBLineMapView *lineMap = [[EBLineMapView alloc] init];
    lineMap.hidden = YES;
    [footerView addSubview:lineMap];
    lineMap.frame = footerView.bounds;
    lineMap.delegate = self;
    lineMap.resultModel = self.resultModel;
    self.lineMapView = lineMap;
}


#pragma mark - Request
- (void)refreshWithLoading:(BOOL)loading {
    if ([EBUserInfo sharedEBUserInfo].loginId.length == 0 || [EBUserInfo sharedEBUserInfo].loginName.length == 0) {
        [self.tableView.header endRefreshing];
        return;
    }
    EB_WS(ws);
    loading ? [MBProgressHUD showMessage:@"加载中..." toView:self.view] : nil;
    NSDictionary *parameters = @{static_Argument_userName   : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId     : [EBUserInfo sharedEBUserInfo].loginId};
    [EBNetworkRequest GET:static_Url_TransferOfRecentLine parameters:parameters dictBlock:^(NSDictionary *dict) {
        [ws.tableView.header endRefreshing];
        if (loading) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        NSDictionary *returnData = dict[static_Argument_returnData];
        if (returnData.count == 0) {
            self.tableViewAppear = NO;
            return;
        } else {
            self.tableViewAppear = YES;
        }
        EBTransferModel *tModel = [[EBTransferModel alloc] initWithDict:returnData];
        EBSearchResultModel *resultModel = [EBSearchResultModel resultModelFromTransferModel:tModel];
        self.resultModel = resultModel;
        self.transferModel = tModel;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        if (loading) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        [ws.tableView.header endRefreshing];
    }];
}

- (void)lineDetailRequest {
    EBLineDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if (model) {
        self.lineMapView.lineDetailM = model;
        return;
    }
    EB_WS(ws);
    if (!self.resultModel.lineId) return;
    NSDictionary *parameters = @{static_Argument_lineId : self.resultModel.lineId};
    [EBNetworkRequest GET:static_Url_LineDetail parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSDictionary *returnData = dict[static_Argument_returnData];
        EBLineDetailModel *lineDetail = [[EBLineDetailModel alloc] initWithDict:returnData];
        [NSKeyedArchiver archiveRootObject:lineDetail toFile:ws.filePath];
        ws.lineMapView.lineDetailM = lineDetail;
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)issueTicketRequest {
    if ([EBUserInfo sharedEBUserInfo].loginId && [EBUserInfo sharedEBUserInfo].loginName && self.transferModel.ID) {
        NSDictionary *parameters = @{static_Argument_userId     : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_userName   : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_id         : self.transferModel.ID};
        [EBNetworkRequest GET:static_Url_IssueTicket parameters:parameters dictBlock:nil errorBlock:nil];
    }
}

#pragma mark - UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = [NSArray seprateString:self.transferModel.runDate characterSet:@"-"];
    if (array.count != 3) return nil;
    NSString *string = [NSString stringWithFormat:@"乘车日期：%@月%@日",array[1], array[2]];
    return self.tableViewAppear ? string : nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewAppear ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tableViewAppear ? 30 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBTransferLineCell *cell = [EBTransferLineCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.model = self.transferModel;
    return cell;
}
#pragma mark - EBTransferLineCellDelegate
- (void)transferLineOutTicktet:(EBTransferLineCell *)transeferLine transerModel:(EBTransferModel *)model type:(EBTicketType)type{
    if (type == EBTicketTypeOfOut) {
        EBTicketViewController *tVC = [[EBTicketViewController alloc] init];
        tVC.transferModel = self.transferModel;
        [self.navigationController pushViewController:tVC animated:YES];
    }
}

@end

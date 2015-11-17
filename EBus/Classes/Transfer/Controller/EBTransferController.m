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
#import "EBTransferTipView.h"
@interface EBTransferController () <EBLineMapViewDelegate, EBTransferLineCellDelegate>

@property(nonatomic, strong) NSString *filePath;//文件路径
@property (nonatomic, strong) EBSearchResultModel *resultModel;
@property (nonatomic, strong) EBTransferModel *transferModel;

@property (nonatomic, assign) BOOL tableViewAppear;
@property (nonatomic, weak) UIView *footerView;
@property (nonatomic, weak) EBLineMapView *lineMapView;
@property (nonatomic, weak) EBTransferTipView *tipView;
@end

@implementation EBTransferController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self footerViewImplementation];
    EB_WS(ws);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshWithLoading:NO];
    }];
    self.tableView.allowsSelection = NO;
    [self refreshWithLoading:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:EBLogoutSuccessNotification object:nil];
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
    
    EBTransferTipView *tipView = [EBTransferTipView transferTipViewFromXib];
    tipView.frame = footerView.bounds;
    tipView.hidden = YES;
    [footerView addSubview:tipView];
    self.tipView = tipView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lineMapView mapViewDidAppear];
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


#pragma mark - UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = [NSString stringWithFormat:@"乘车日期：%@",self.transferModel.runDate];
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
    EBLog(@"%@, %ld",NSStringFromSelector(_cmd), type);
    if (type == EBTicketTypeOfOut) {
        self.lineMapView.hidden = YES;
        self.tipView.hidden = NO;
        self.tipView.transferModel = model;
    } else if (type == EBTicketTypeOfCheckLine) {
        self.lineMapView.hidden = NO;
        self.tipView.hidden = YES;
    } else if (type == EBTicketTypeOfWaiting) {
        [MBProgressHUD showError:@"乘车前30分钟出票" toView:self.view];
    }
}

@end

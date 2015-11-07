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
#import "EBSearchResultModel.h"
#import "EBUsualLineCell.h"
#import "EBLineDetailModel.h"
#import "EBUserInfo.h"
#import "EBTransferModel.h"

@interface EBTransferController () <EBLineMapViewDelegate>
@property (nonatomic, weak) EBLineMapView *lineMapView;
@property(nonatomic, strong) NSString *filePath;//文件路径

@property (nonatomic, strong) EBSearchResultModel *resultModel;

@end

@implementation EBTransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageViewDisappear = NO;
    self.navigationItem.title = @"乘车";
    
    EBLineMapView *lineMap = [[EBLineMapView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar - EB_HeightOfTabBar - 30)];
    lineMap.delegate = self;
    lineMap.resultModel = self.resultModel;
    self.tableView.tableFooterView = lineMap;
    self.tableView.allowsSelection = NO;
    self.lineMapView = lineMap;
    
    EB_WS(ws);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refresh];
    }];
    [self.tableView.header beginRefreshing];
    
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lineId.arc",self.resultModel.lineId]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lineMapView mapViewDidAppear];
}

- (void)refresh {
    if ([EBUserInfo sharedEBUserInfo].loginId.length == 0 || [EBUserInfo sharedEBUserInfo].loginName.length == 0) return;
    EB_WS(ws);
    NSDictionary *parameters = @{static_Argument_userName   : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_userId     : [EBUserInfo sharedEBUserInfo].loginId};
    [EBNetworkRequest GET:static_Url_TransferOfRecentLine parameters:parameters dictBlock:^(NSDictionary *dict) {
        [ws.tableView.header endRefreshing];
        NSDictionary *returnData = dict[static_Argument_returnData];
        if (returnData.count == 0) return;
        EBTransferModel *tModel = [[EBTransferModel alloc] initWithDict:returnData];
        EBSearchResultModel *resultModel = [[EBSearchResultModel alloc] init];
    } errorBlock:^(NSError *error) {
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
    return @"乘车";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
    cell.showBuyView = NO;
    cell.model = self.resultModel;
    return cell;
}
@end

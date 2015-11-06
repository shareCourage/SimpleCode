//
//  EBTransferController.m
//  EBus
//
//  Created by Kowloon on 15/11/6.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferController.h"
#import "EBLineMapView.h"
#import "EBSearchResultModel.h"
#import "EBUsualLineCell.h"
#import "EBLineDetailModel.h"

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
    
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lineId.arc",self.resultModel.lineId]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lineMapView mapViewDidAppear];
    [self lineDetailRequest];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.lineMapView mapViewDidDisappear];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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

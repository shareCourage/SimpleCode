//
//  EBLineDetailController.m
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineDetailController.h"
#import "EBUsualLineCell.h"
#import "EBLineMapView.h"
#import "EBSearchResultModel.h"
#import "EBLineDetailModel.h"
#import "EBBuyTicketController.h"

@interface EBLineDetailController () <EBLineMapViewDelegate>

@property (nonatomic, weak) EBLineMapView *lineMapView;
@property(nonatomic, strong) NSString *filePath;//文件路径

@end

@implementation EBLineDetailController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线路详情";
    EBLineMapView *lineMap = [[EBLineMapView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
    lineMap.delegate = self;
    lineMap.onStationTime = self.resultModel.startTime;
    self.tableView.tableFooterView = lineMap;
    self.tableView.allowsSelection = NO;
    self.lineMapView = lineMap;
    
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lineId.arc",self.resultModel.lineId]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCenter) name:EBLoginSuccessNotification object:nil];
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
- (void)loginCenter {
    [self pushToTicket];
}
- (void)pushToTicket {
    EBBuyTicketController *buyT = [[EBBuyTicketController alloc] init];
    buyT.resultModel = self.resultModel;
    [self.navigationController pushViewController:buyT animated:YES];
}
#pragma mark - EBLineMapViewDelegate
- (void)lineMapViewBuyClick:(EBLineMapView *)lineMapView {
    if (![EBTool presentLoginVC:self completion:nil]) {
        [self pushToTicket];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

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
#import "EBUserInfo.h"
#import "PHTabBarController.h"

@interface EBLineDetailController () <EBLineMapViewDelegate>

@property (nonatomic, weak) EBLineMapView *lineMapView;
@property(nonatomic, strong) NSString *filePath;//文件路径

@end

@implementation EBLineDetailController
- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线路详情";
    EBLineMapView *lineMap = [[EBLineMapView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
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

- (void)pushToTicket {
    NSUInteger openType = [self.resultModel.openType integerValue];
    if (openType == 1) {//购买
        EBBuyTicketController *buyT = [[EBBuyTicketController alloc] init];
        buyT.resultModel = self.resultModel;
        [self.navigationController pushViewController:buyT animated:YES];
    } else if (openType == 2) {//报名
        [self signApply];
    } else if (openType == 3) { //团购
        [self signApply];
    }
}

- (void)signApply {
    if (self.resultModel.lineId && self.resultModel.onStationId && self.resultModel.offStationId ) {
        NSDictionary *parameters = @{static_Argument_customerId     : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_customerName   : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_lineId         : self.resultModel.lineId,
                                     static_Argument_vehTime        : self.resultModel.vehTime,
                                     static_Argument_onStationId    : self.resultModel.onStationId,
                                     static_Argument_offStationId   : self.resultModel.offStationId,
                                     static_Argument_startTime      : self.resultModel.startTime};
        [EBNetworkRequest POST:static_Url_Sign parameters:parameters dictBlock:^(NSDictionary *dict) {
            NSString *code = dict[static_Argument_returnCode];
            NSString *info = dict[static_Argument_returnInfo];
            if ([code integerValue] == 500) {
                PHTabBarController *phTBC = (PHTabBarController *)self.tabBarController;
                phTBC.mySelectedIndex = 2;
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else if ([info isEqualToString:@"已报名"]){
                [MBProgressHUD showSuccess:@"已报名" toView:self.view];
            } else {
                [MBProgressHUD showError:@"报名失败" toView:self.view];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD showError:@"报名失败" toView:self.view];
        }];
    }
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

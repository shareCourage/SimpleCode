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
#import "EBPhotoViewController.h"
#import "EBLineStation.h"
@interface EBLineDetailController () <EBLineMapViewDelegate>

@property (nonatomic, weak) EBLineMapView *lineMapView;
@property(nonatomic, strong) NSString *filePath;//文件路径

@end

@implementation EBLineDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"班次详情";
    EBLineMapView *lineMap = [[EBLineMapView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
    lineMap.delegate = self;
    lineMap.resultModel = self.resultModel;
    self.tableView.tableFooterView = lineMap;
    self.tableView.allowsSelection = NO;
    self.lineMapView = lineMap;
    
    self.filePath = [[EBTool filePathOfLineId] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@lineId.arc",self.resultModel.lineId]];
    EBLog(@"filePath-> %@",self.filePath);
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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.resultModel.lineId) {
        [parameters setObject:self.resultModel.lineId forKey:static_Argument_lineId];
    }
    [EBNetworkRequest GET:static_Url_LineDetail parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSString *code = dict[static_Argument_returnCode];
        if ([code integerValue] == 500) {
            NSDictionary *returnData = dict[static_Argument_returnData];
            EBLineDetailModel *lineDetail = [[EBLineDetailModel alloc] initWithDict:returnData];
            BOOL value = [NSKeyedArchiver archiveRootObject:lineDetail toFile:self.filePath];
            if (value) {
                EBLog(@"NSKeyedArchiver -> success");
            } else {
                EBLog(@"NSKeyedArchiver -> failure");
            }
            self.lineMapView.lineDetailM = lineDetail;
        } else {
            [MBProgressHUD showError:@"线路不存在" toView:self.view];
            self.lineMapView.lineDetailM = nil;
        }
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
        [self signApply:@"报名"];
    } else if (openType == 3) { //跟团
        [self signApply:@"跟团"];
    }
}

- (void)signApply:(NSString *)title {
    NSUInteger openType = [self.resultModel.openType integerValue];
//    NSString *success = [NSString stringWithFormat:@"%@成功",title];
    NSString *beenSuccess = [NSString stringWithFormat:@"已%@",title];
    NSString *failure = [NSString stringWithFormat:@"%@失败",title];
    if (self.resultModel.lineId && self.resultModel.onStationId && self.resultModel.offStationId ) {
        NSDictionary *parameters = @{static_Argument_customerId     : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_customerName   : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_lineId         : self.resultModel.lineId,
                                     static_Argument_onStationId    : self.resultModel.onStationId,
                                     static_Argument_offStationId   : self.resultModel.offStationId};
        NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        if (self.resultModel.vehTime.length != 0) {
            [mParameters setObject:self.resultModel.vehTime forKey:static_Argument_vehTime];
        }
        if (self.resultModel.startTime.length != 0) {
            [mParameters setObject:self.resultModel.startTime forKey:static_Argument_startTime];
        }
        [EBNetworkRequest POST:static_Url_Sign parameters:mParameters dictBlock:^(NSDictionary *dict) {
            NSString *code = dict[static_Argument_returnCode];
            NSString *info = dict[static_Argument_returnInfo];
            if ([code integerValue] == 500) {
                [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (openType == 2) {
                        [EBTool popToAttentionControllWithIndex:1 controller:self];
                    } else if (openType == 3) {
                        [EBTool popToAttentionControllWithIndex:2 controller:self];
                    }
                });
            } else if ([info isEqualToString:beenSuccess]){
                [MBProgressHUD showSuccess:beenSuccess toView:self.view];
            } else {
                [MBProgressHUD showError:failure toView:self.view];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD showError:failure toView:self.view];
        }];
    }
}
#pragma mark - EBLineMapViewDelegate
- (void)lineMapViewBuyClick:(EBLineMapView *)lineMapView {
    if (![EBTool presentLoginVC:self completion:nil]) {
        [self pushToTicket];
    }
}
- (void)lineMapViewCheckPhoto:(EBLineMapView *)lineMapView lineDetail:(EBLineStation *)lineM {
    EBLog(@"lineMapViewCheckPhoto -> %@, %@, %@", lineM.station, lineM.time, lineM.jid);
    [EBNetworkRequest GET:static_Url_LinePhoto parameters:@{static_Argument_bcStationId : lineM.jid} dictBlock:^(NSDictionary *dict) {
        NSString *urlStr = dict[static_Argument_returnData];
        if (urlStr.length == 0) {
            [MBProgressHUD showError:@"该站点暂时没有图片" toView:self.view];
            return;
        } else {
            EBPhotoViewController *photo = [[EBPhotoViewController alloc] init];
            photo.urlOfImage = urlStr;
            [self presentViewController:photo animated:YES completion:nil];
        }
    } errorBlock:nil];
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

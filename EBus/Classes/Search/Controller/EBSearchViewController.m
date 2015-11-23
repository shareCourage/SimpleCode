//
//  EBSearchViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/14.
//  Copyright © 2015年 Goome. All rights reserved.
//
#import "EBSearchViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "AppDelegate.h"
#import "EBSelectPositionController.h"
#import "EBSearchResultController.h"
#import "EBSearchBusView.h"
#import "EBUsualLineCell.h"
#import "EBSearchResultModel.h"
#import "EBHotView.h"
#import "EBHotLabel.h"
#import "EBLineDetailController.h"
#import "EBUserInfo.h"

@interface EBSearchViewController () <EBSearchBusViewDelegate, EBUsualLineCellDelegate, EBHotViewDelegate, MAMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) EBSearchBusView *searchBusView;
@property (nonatomic, weak) EBHotView *hotView;
@property (nonatomic, weak) MAMapView *maMapView;

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;
@property (nonatomic, assign) BOOL comeFromSelPosition;//是否来自用户自己的选择
@end

@implementation EBSearchViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        if ([EBTool loginEnable]) {
            _dataSource = [EBTool usualLineArrayFromLocal];
        }
        _dataSource.count == 0 ? (self.backgroundImageViewDisappear = NO) : (self.backgroundImageViewDisappear = YES);
    }
    return _dataSource;
}
- (void)usualLineSavedNotification {
    self.dataSource = [EBTool usualLineArrayFromLocal];
    self.dataSource.count == 0 ? (self.backgroundImageViewDisappear = NO) : (self.backgroundImageViewDisappear = YES);
    [self.tableView reloadData];
}

- (void)loginNotification {
    [self usualLineSavedNotification];
}

- (void)logoutNotification {
    [self.dataSource removeAllObjects];
    self.backgroundImageViewDisappear = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查询";
    self.maMapView = [EBUserInfo sharedEBUserInfo].maMapView;
    self.myPositionCoord = kCLLocationCoordinate2DInvalid;
    self.endPositionCoord = kCLLocationCoordinate2DInvalid;
    [self searchBusViewImplementation];
    [self itemImplementation];
    [self hotViewImplementation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usualLineSavedNotification) name:EBDidSaveUsualLineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:EBLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:EBLogoutSuccessNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.maMapView.delegate = self;
    self.maMapView.showsUserLocation = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.maMapView.delegate = nil;
}

- (void)searchBusViewImplementation {
    EBSearchBusView *searchBusView = [[EBSearchBusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    searchBusView.delegate = self;
    self.tableView.tableHeaderView = searchBusView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchBusView = searchBusView;
}
- (void)itemImplementation {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotBtn.frame = CGRectMake(0, 0, 40, 30);
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [hotBtn setTitle:@"HOT" forState:UIControlStateNormal];
    [hotBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [hotBtn addTarget:self action:@selector(hotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithCustomView:hotBtn];
    self.navigationItem.rightBarButtonItem = hotItem;
}

- (void)hotViewImplementation {
    EBHotView *hotView = [EBHotView hotViewFromXib];
    hotView.delegate = self;
    hotView.frame = CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen);
    hotView.hidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:hotView];
    self.hotView = hotView;
    [self hotLabelRequest];
}

- (void)hotLabelRequest {
    EB_WS(ws);
    [EBNetworkRequest GET:static_Url_HotLabel parameters:nil dictBlock:^(NSDictionary *dict) {
        NSArray *returnData = dict[static_Argument_returnData];
        NSMutableArray *hots = [NSMutableArray array];
        for (NSDictionary *obj in returnData) {
            EBHotLabel *hot = [[EBHotLabel alloc] initWithDict:obj];
            [hots addObject:hot];
        }
        ws.hotView.hots = [hots copy];
    } errorBlock:nil indicatorVisible:NO];
}

#pragma mark - Method
- (void)hotBtnClick {
    [UIView animateWithDuration:0.5f animations:^{
        self.hotView.hidden = !self.hotView.hidden;
    } completion:^(BOOL finished) {
        if (!self.hotView.hidden) {
            [self.view.window bringSubviewToFront:self.hotView];
        }
    }];
    if (!self.hotView.hidden) {
        if (self.hotView.hots.count == 0) {
            [self hotLabelRequest];
        }
    }
}
#pragma mark - EBHotViewDelegate
- (void)hotView:(EBHotView *)hotView didSelectIndex:(NSUInteger)index hotLabel:(EBHotLabel *)hotLabel{
    EBLog(@"%ld, %@",(unsigned long)index, hotLabel.name);
    hotView.hidden = YES;
    EBSearchResultController *result = [[EBSearchResultController alloc] init];
    result.hotLabel = hotLabel;
    [self.navigationController pushViewController:result animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"常用路线";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.priceViewHiden = YES;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EBSearchResultModel *result = self.dataSource[indexPath.row];
    [self pushToLineDetailController:result];
}
- (void)pushToLineDetailController:(EBSearchResultModel *)model {
    EBLineDetailController *detail = [[EBLineDetailController alloc] init];
    if (model.lineId && model.vehTime) {
        NSDictionary *parameters = @{static_Argument_lineId : model.lineId,
                                     static_Argument_vehTime : model.vehTime};
        [MBProgressHUD showMessage:nil toView:self.view];
        [EBNetworkRequest GET:static_Url_LinePrice parameters:parameters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *code = dict[static_Argument_returnCode];
            NSNumber *data = dict[static_Argument_returnData];
            if ([code integerValue] == 500) {
                model.price = data;
                detail.resultModel = model;
                [self.navigationController pushViewController:detail animated:YES];
            } else {
                [MBProgressHUD showError:@"获取价格失败" toView:self.view];
            }

        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"获取价格失败" toView:self.view];
        }];
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /**
         *1、删除数据源
         *2、tableView的删除
         *3、删除服务器上的数据
         *4、如果做了本地数据库保存，同样需要删除
         */
        [self.dataSource removeObjectAtIndex:indexPath.row];//1 删除数据源
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//2 tableView的删除
        [EBTool saveUsualLineToLocalWithArray:self.dataSource];//4、对数据的重新归档，就相当于删除
        self.dataSource.count == 0 ? (self.backgroundImageViewDisappear = NO) : (self.backgroundImageViewDisappear = YES);
    }
}


#pragma mark - EBUsualLineCellDelegate
- (void)usualLineDidClick:(EBUsualLineCell *)usualLine type:(EBSearchBuyType)type{
    EBLog(@"usualLineDidClick");
}

#pragma mark - EBSearchBusViewDelegate
- (void)searchBusView:(EBSearchBusView *)searchBusView clickType:(EBSearchBusClickType)type {
    switch (type) {
        case EBSearchBusClickTypeMyPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeEndPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeDeleteOfMyPosition:
            self.myPositionCoord = kCLLocationCoordinate2DInvalid;
            self.comeFromSelPosition = YES;
            break;
        case EBSearchBusClickTypeDeleteOfEndPosition:
            self.endPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeSearch:
            [self searchSpecificBus];
            break;
        case EBSearchBusClickTypeExchange:
        {
            CLLocationCoordinate2D coord = self.myPositionCoord;
            self.myPositionCoord = self.endPositionCoord;
            self.endPositionCoord = coord;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Method
- (void)selectPosition:(EBSearchBusClickType)type {
    EB_WS(ws);
    EBSelectPositionController *selectC = [[EBSelectPositionController alloc] initWithOption:^(NSString *title, CLLocationCoordinate2D coord) {
        ws.comeFromSelPosition = YES;
        if (type == EBSearchBusClickTypeMyPosition) {
            ws.searchBusView.myPositionTitle = title;
            ws.myPositionCoord = coord;
        } else if (type == EBSearchBusClickTypeEndPosition) {
            ws.searchBusView.endPositionTitle = title;
            ws.endPositionCoord = coord;
        }
    }];
    [self.navigationController pushViewController:selectC animated:YES];
}

- (void)searchSpecificBus {
    BOOL my = CLLocationCoordinate2DIsValid(self.myPositionCoord);
    BOOL end = CLLocationCoordinate2DIsValid(self.endPositionCoord);
    if (my || end) {
        EBSearchResultController *result = [[EBSearchResultController alloc] init];
        result.myPositionCoord = self.myPositionCoord;
        result.endPositionCoord = self.endPositionCoord;
        [self.navigationController pushViewController:result animated:YES];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    EBLog(@"mapViewLocation -> %.6f, %.6f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D coord = userLocation.location.coordinate;
    if ([EBTool locationEnable]) {
        [EBUserInfo sharedEBUserInfo].userLocation = coord;
    }
    mapView.userTrackingMode = MAUserTrackingModeNone;//加这句代码，当调用定位时，可以让mapView不执行regionDidChange方法
    if (!self.comeFromSelPosition && [EBTool locationEnable]) {
        self.myPositionCoord = coord;
        self.searchBusView.myPositionTitle = @"我的位置";
    }
}

@end





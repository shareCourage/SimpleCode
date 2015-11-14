//
//  EBSelectPositionController.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_HeightOfMapView EB_HeightOfScreen > 480 ? 250 : 200
#import "EBSelectPositionController.h"
#import "EBSearchMapView.h"
#import <Masonry/Masonry.h>
#import "EBSelectPositionCell.h"
#import "EBSelectPositionModel.h"
#import "EBAnnotation.h"
#import "EBSPButton.h"
#import "EBSearchAddressController.h"

@interface EBSelectPositionController () <UITableViewDataSource, UITableViewDelegate, EBSearchMapViewDelegate, EBSelectPositionCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) EBSearchMapView *searchMapView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) EBAnnotation *selectAnnotation;
@property (nonatomic, strong) EBSelectPositionModel *locationModel;

@property (nonatomic, copy) void (^option) (NSString *title, CLLocationCoordinate2D coord);
@property (nonatomic, copy) void (^extraOption) (NSString *title, NSString *district, CLLocationCoordinate2D coord);

@end

@implementation EBSelectPositionController

- (instancetype)initWithOption:(void (^)(NSString *title, CLLocationCoordinate2D coord))option {
    self = [super init];
    if (self) {
        self.option = option;
    }
    return self;
}

- (instancetype)initWithExtraOption:(void (^)(NSString *, NSString *, CLLocationCoordinate2D))option {
    self = [super init];
    if (self) {
        self.extraOption = option;
    }
    return self;
}

- (EBSelectPositionModel *)locationModel {
    if (_locationModel == nil) {
        _locationModel = [EBTool locationEnable] ? [[EBSelectPositionModel alloc] init] : nil;
        _locationModel.selected = YES;
        if (self.dataSource.count >= 1) {//为了第一次启动判断定位是否开启执行的代码
            EBSelectPositionModel *first = [self.dataSource firstObject];
            if (!first.regeocode) {
                [self.dataSource insertObject:self.locationModel atIndex:0];
                [self.tableView reloadData];
            }
        }
    }
    return _locationModel;
}

- (EBAnnotation *)selectAnnotation {
    if (_selectAnnotation == nil) {
        _selectAnnotation = [[EBAnnotation alloc] init];
        _selectAnnotation.imageString = @"";
    }
    return _selectAnnotation;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        if (self.locationModel) {
            [_dataSource addObject:self.locationModel];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self titleViewImplementation];
    [self searchMapViewImplementation];
    [self tableViewImplementation];
}
- (void)titleViewImplementation {
    EBSPButton *searchBtn = [EBSPButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, EB_WidthOfScreen - 70, 35);
    [searchBtn setTitle:@"地址查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAddressClick) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBtn.layer.borderWidth = .5f;
    searchBtn.layer.cornerRadius = searchBtn.height / 2;
    self.navigationItem.titleView = searchBtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchMapView mapViewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchMapView mapViewDidDisappear];
}

- (void)searchAddressClick {
    EBSearchAddressController *address = [[EBSearchAddressController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
}

#pragma mark - Instance
- (void)searchMapViewImplementation {
    EBSearchMapView *mapView = [[EBSearchMapView alloc] initWithFrame:CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, EB_HeightOfMapView)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.searchMapView = mapView;
}

- (void)tableViewImplementation {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    EB_WS(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.searchMapView.mas_bottom).with.offset(0);
        make.left.equalTo(ws.view).with.offset(0);
        make.bottom.equalTo(ws.view).with.offset(0);
        make.right.equalTo(ws.view).with.offset(0);
    }];
}
#pragma mark - Method
- (void)addAnnotation:(EBSelectPositionModel *)selectModel {
    [self.searchMapView.maMapView removeAnnotation:self.selectAnnotation];
    AMapPOI *poi = selectModel.poi;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    self.selectAnnotation.coordinate = coord;
    [self.searchMapView.maMapView addAnnotation:self.selectAnnotation];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [EBTool locationEnable] ? self.dataSource.count + 1 : self.dataSource.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBSelectPositionCell *cell = [EBSelectPositionCell cellWithTableView:tableView];
    cell.delegate = self;
    EBSelectPositionModel *selectModel = self.dataSource[indexPath.row];
    cell.selectModel = selectModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedIndexPath) {
        EBSelectPositionModel *previousModel = self.dataSource[self.selectedIndexPath.row];
        previousModel.selected = NO;
    }
    EBSelectPositionModel *selectModel = self.dataSource[indexPath.row];
    selectModel.selected = YES;
    
    [self addAnnotation:selectModel];
    
    if (self.selectedIndexPath) {
        [tableView reloadRowsAtIndexPaths:@[indexPath, self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    self.selectedIndexPath = indexPath;
}

#pragma mark - EBSearchMapViewDelegate 
- (void)searchMapView:(EBSearchMapView *)searchMapView poiSearch:(NSArray *)places {
    if ([EBTool locationEnable]) {
        [self.dataSource removeObjectsInRange:NSMakeRange(1, self.dataSource.count - 1)];
    } else {
        [self.dataSource removeAllObjects];
    }
    NSMutableArray *mArray = [NSMutableArray array];
    for (AMapPOI *poi in places) {
        EBSelectPositionModel *selectModel = [[EBSelectPositionModel alloc] init];
        selectModel.poi = poi;
        [mArray addObject:selectModel];
    }
    [self.dataSource addObjectsFromArray:mArray];
    [self.tableView reloadData];
}

- (void)searchMapView:(EBSearchMapView *)searchMapView locationReGeocode:(AMapReGeocode *)reGeocode location:(CLLocation *)location{
    if (self.locationModel) {
        self.locationModel.regeocode = reGeocode;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - EBSelectPositionCellDelegate
- (void)selectPositionSureClick:(EBSelectPositionCell *)selectPositionCell title:(NSString *)title coord:(CLLocationCoordinate2D)coord district:(NSString *)district{
    EBLog(@"selectPositionSureClick");
    [self.navigationController popViewControllerAnimated:YES];
    if (self.option) self.option(title, coord);
    if (self.extraOption) self.extraOption(title, district, coord);
}

@end





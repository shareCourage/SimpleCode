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
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) EBAnnotation *selectAnnotation;

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
    }
    if (_dataSource.count > 0) {
        self.backgroundImageView.hidden = YES;
    } else {
        self.backgroundImageView.hidden = NO;
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleViewImplementation];
    [self searchMapViewImplementation];
    [self tableViewImplementation];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}
- (void)titleViewImplementation {
    EBSPButton *searchBtn = [EBSPButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"search_navi_check"] forState:UIControlStateNormal];
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
    EB_WS(ws);
    EBSearchAddressController *address = [[EBSearchAddressController alloc] initWithOption:^BOOL(AMapPOI *poi) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        if(ws.option) {//如果是从EBSearchViewController push过来的，则返回NO
            ws.option(poi.name, coord);
            return NO;
        }
        if(ws.extraOption) {//如果是从EBSponsorController push过来的，则返回YES
            ws.extraOption(poi.name, poi.district, coord);
            return YES;
        }
        return YES;
    }];
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
    UIImageView *backgroundImageView = [EBTool backgroundImageView];
    tableView.backgroundView = backgroundImageView;
    self.backgroundImageView = backgroundImageView;
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
    for (EBSelectPositionModel *seM in self.dataSource) {
        seM.selected = NO;
    }
    EBSelectPositionModel *selectModel = self.dataSource[indexPath.row];
    selectModel.selected = YES;
    [tableView reloadData];
    [self addAnnotation:selectModel];
}

#pragma mark - EBSearchMapViewDelegate 
- (void)searchMapView:(EBSearchMapView *)searchMapView poiSearch:(NSArray *)places {
    [self.dataSource removeAllObjects];
    NSMutableArray *mArray = [NSMutableArray array];
    NSInteger index = 0;
    for (AMapPOI *poi in places) {
        EBSelectPositionModel *selectModel = [[EBSelectPositionModel alloc] init];
        if (index == 0) {
            selectModel.selected = YES;
        }
        selectModel.poi = poi;
        [mArray addObject:selectModel];
        index ++;
    }
    [self.dataSource addObjectsFromArray:mArray];
    [self.tableView reloadData];
}


#pragma mark - EBSelectPositionCellDelegate
- (void)selectPositionSureClick:(EBSelectPositionCell *)selectPositionCell title:(NSString *)title coord:(CLLocationCoordinate2D)coord district:(NSString *)district{
    EBLog(@"selectPositionSureClick");
    [self.navigationController popViewControllerAnimated:YES];
    if (self.option) self.option(title, coord);
    if (self.extraOption) self.extraOption(title, district, coord);
}

@end





//
//  EBSearchMapView.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_ImageName_LocationBtn @"home_current_highlighted"

#import "EBSearchMapView.h"
#import "EBUserInfo.h"

@interface EBSearchMapView ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, weak) UIButton *myLocation;//用来切换地图的中心点
@property (nonatomic, weak) UIImageView *centerImageView;

@property (nonatomic, strong) AMapSearchAPI *searchPOI;

@end

@implementation EBSearchMapView



- (AMapSearchAPI *)searchPOI {
    if (_searchPOI == nil) {
        _searchPOI = [[AMapSearchAPI alloc] init];
        _searchPOI.delegate = self;
    }
    return _searchPOI;
}

- (void)mapViewDidAppear {
    [super mapViewDidAppear];
    self.maMapView.delegate = self;
    self.maMapView.zoomLevel = 15;
    if (![EBTool locationEnable]) {//开启了定位，这里就不用设置地图中心了
        CLLocationCoordinate2D centerCL = [EBUserInfo sharedEBUserInfo].userLocation;
        [self.maMapView setCenterCoordinate:centerCL];
    }
}

- (void)mapViewDidDisappear {
    [super mapViewDidDisappear];
    self.maMapView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [EBTool locationEnable] ? [self addLocationButton] : nil;
        [self addCenterImageViewMethod];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [EBTool locationEnable] ? [self addLocationButton] : nil;
        [self addCenterImageViewMethod];
    }
    return self;
}

#pragma mark - addWidget
- (void)addLocationButton {
    UIButton *location  = [UIButton buttonWithType:UIButtonTypeCustom];
    [location setImage:[UIImage imageNamed:EB_ImageName_LocationBtn] forState:UIControlStateNormal];
    [location addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:location];
    self.myLocation = location;

}

- (void)addCenterImageViewMethod {
    UIImageView *center = [[UIImageView alloc] init];
    center.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *centerImage = [UIImage imageNamed:@"icon_line_begin"];
    center.layer.anchorPoint = CGPointMake(0.5, 1);
    center.image = centerImage;
    [self addSubview:center];
    self.centerImageView = center;
}

- (void)locationBtnClick {
    if (self.maMapView.userLocation) {
        [self.maMapView setCenterCoordinate:self.maMapView.userLocation.location.coordinate animated:YES];
    }
}

#pragma mark - 使用autoLayout设定子控件的frame
//self添加子控件的时候，设置frame
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [EBTool locationEnable] ? [self setLocationBtnAutoLayout] : nil;
    [self setCenterImageViewAutoLayout];
}

- (void)setLocationBtnAutoLayout {
    EB_WS(ws);
    CGFloat padding = 10.0f;
    CGFloat heightBtn = 40.0f;
    CGFloat widthBtn = 35.0f;
    [self.myLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn));//高度
        make.width.mas_equalTo(@(widthBtn));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-padding);//离父控件右边10
        make.top.equalTo(ws.mas_top).with.offset(padding);//
    }];
}

- (void)setCenterImageViewAutoLayout {
    EB_WS(ws);
    CGFloat width = 20.0f;
    CGFloat height = 20.0f;
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.height.mas_equalTo(@(height));//高度
        make.width.mas_equalTo(@(width));//高度
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    EBLog(@"mapViewLocation -> %.6f, %.6f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D coord = userLocation.location.coordinate;
    if ([EBTool locationEnable]) {
        [EBUserInfo sharedEBUserInfo].userLocation = coord;
        [mapView setCenterCoordinate:coord];
    }
    mapView.showsUserLocation = NO;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    EBLog(@"centerCoordinate ->  %.6f, %.6f, %.f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude, mapView.zoomLevel);
    [self poiSearchThroughAMAP:mapView.centerCoordinate];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    for (AMapPOI *obj in response.pois) {
        EBLog(@"%@, %@", obj.name, obj.address);
    }
    [self callSelfDelegate:response];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    [self callSelfDelegate:response];
}

#pragma mark - Method
- (void)poiSearchThroughAMAP:(CLLocationCoordinate2D)coord {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
    request.keywords = @"商业|大厦";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|商务住宅|生活服务|交通设施服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [self.searchPOI AMapPOIAroundSearch:request];
}

- (void)locationSearchThroughAMAP:(CLLocationCoordinate2D)coord {
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
    request.requireExtension = YES;
    [self.searchPOI AMapReGoecodeSearch:request];
}

- (void)callSelfDelegate:(id)obj {
    if ([obj isKindOfClass:[AMapPOISearchResponse class]]) {
        AMapPOISearchResponse *response = obj;
        if ([self.delegate respondsToSelector:@selector(searchMapView:poiSearch:)]) {
            [self.delegate searchMapView:self poiSearch:response.pois];
        }
    } else if ([obj isKindOfClass:[AMapReGeocodeSearchResponse class]]) {
        AMapReGeocodeSearchResponse *response = obj;
        if ([self.delegate respondsToSelector:@selector(searchMapView:locationReGeocode:location:)]) {
            [self.delegate searchMapView:self locationReGeocode:response.regeocode location:self.maMapView.userLocation.location];
        }
    }
    
}

@end




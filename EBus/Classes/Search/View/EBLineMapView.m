//
//  EBLineMapView.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_LineColor EB_RGBColor(90, 138, 251)
#define EB_MaxWidthOfLineStation (EB_WidthOfScreen / 2 + 80) //左边滑动的view的最大宽度值
#import "EBLineMapView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "EBLineDetailModel.h"
#import "EBAnnotation.h"
#import "EBAnnotationView.h"
#import "EBPPAnnotation.h"
#import "EBLineDetailPPAnnotationView.h"
#import "EBLineStationView.h"
#import "EBLineStation.h"
#import "EBSearchResultModel.h"

//高德地图规划线路用的类
#import "CommonUtility.h"

@interface EBLineMapView () <MAMapViewDelegate, AMapSearchDelegate, EBLineStationViewDelegate, EBLineDetailPPAnnotationViewDelegate>
{
    BOOL _value;//YES 表示leftDragView在右边，NO在左边
}
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *buyBtn;

@property (nonatomic, weak) EBLineStationView *stationView;

@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, weak) UIView *leftDragView;

@property (nonatomic, weak) UIView *leftView;

@property (nonatomic, strong) AMapSearchAPI *searchPOI;

@end

@implementation EBLineMapView
//懒加载
- (AMapSearchAPI *)searchPOI {
    if (_searchPOI == nil) {
        _searchPOI = [[AMapSearchAPI alloc] init];
        _searchPOI.delegate = self;
    }
    return _searchPOI;
}

#pragma mark - Setter
- (void)setResultModel:(EBSearchResultModel *)resultModel {
    
    _resultModel = resultModel;
    if ([resultModel.openType integerValue] == 1) {
        [self.buyBtn setTitle:@"购票" forState:UIControlStateNormal];
    } else if ([resultModel.openType integerValue] == 2) {
        [self.buyBtn setTitle:@"报名" forState:UIControlStateNormal];
    } else if ([resultModel.openType integerValue] == 3) {
        [self.buyBtn setTitle:@"跟团" forState:UIControlStateNormal];
    }
    if (!resultModel.openType) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }
}
- (void)setLineDetailM:(EBLineDetailModel *)lineDetailM {
    _lineDetailM = lineDetailM;
    if (!lineDetailM) {
        [self.buyBtn setBackgroundColor:[UIColor grayColor]];
        self.buyBtn.userInteractionEnabled = NO;
        return;
    }
    NSUInteger openType = [lineDetailM.openType integerValue];
    if (openType == 1 || openType == 2) {//购买
        if (lineDetailM.lineContent.length == 0) return;
        [self prepareDataSourceForLineStationView:lineDetailM];
        NSArray *coords = [NSArray seprateString:lineDetailM.lineContent characterSet:@";"];
        [self addPolylineWithCoords:coords];
        [self.maMapView setCenterCoordinate:[self averageCoord:coords] animated:NO];
    } else if (openType == 3) { //跟团
        self.leftView.hidden = YES;
        [self drivingRouteRequest:lineDetailM];
    }
}

#pragma mark - 驾车路径规划
- (void)drivingRouteRequest:(EBLineDetailModel *)lineDetailM {
    /* 驾车路径规划搜索. */
    NSArray *onLngLats = [NSArray seprateString:lineDetailM.onLngLat characterSet:@","];
    NSArray *offLngLats = [NSArray seprateString:lineDetailM.offLngLat characterSet:@","];
    NSString *onlat = [onLngLats lastObject];
    NSString *onlng = [onLngLats firstObject];
    NSString *offlat = [offLngLats lastObject];
    NSString *offlng = [offLngLats firstObject];
    if (onLngLats.count != 2 || offLngLats.count != 2) return;
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:[onlat doubleValue] longitude:[onlng doubleValue]];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:[offlat doubleValue] longitude:[offlng doubleValue]];
    [self.searchPOI AMapDrivingRouteSearch:navi];
}


#pragma mark - 为EBLineStationView准备dataSource
- (void)prepareDataSourceForLineStationView:(EBLineDetailModel *)lineM {
    if (!lineM) return;
    NSMutableArray *dataSource = [NSMutableArray array];
    NSArray *onStationsArray = [lineM.onStations componentsSeparatedByString:@";"];
    NSArray *onLngLats = [lineM.onLngLat componentsSeparatedByString:@";"];
    NSArray *onTimes = [lineM.onTimes componentsSeparatedByString:@";"];
    NSArray *onFjIdsArray = [NSArray seprateString:lineM.onFjIds characterSet:@";"];
    if (onStationsArray.count != onLngLats.count) return;
    if (onStationsArray.count != onTimes.count) return;
    if (onStationsArray.count != onFjIdsArray.count) return;
    NSUInteger i = 0;
    for (NSString *onStation in onStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = onStation;
        station.coordinate = [EBTool coordFromString:onLngLats[i]];
        station.time = onTimes[i];
        station.jid = onFjIdsArray[i];
        station.on = YES;
        EBAnnotation *annotation = [[EBAnnotation alloc] init];
        if (i == 0) {
            station.firstOrEnd = YES;
            annotation.imageString = @"search_map_depart";
        } else {
            station.firstOrEnd = NO;
            annotation.imageString = @"search_map_departPass";
        }
        annotation.lineInfo = station;
        [dataSource addObject:annotation];
        i ++;
    }
    
    NSArray *offStationsArray = [lineM.offStations componentsSeparatedByString:@";"];
    NSArray *offLngLats = [lineM.offLngLat componentsSeparatedByString:@";"];
    NSArray *offTimes = [lineM.offTimes componentsSeparatedByString:@";"];
    NSArray *offFjIdsArray = [NSArray seprateString:lineM.offFjIds characterSet:@";"];
    if (offStationsArray.count != offLngLats.count) return;
    if (offStationsArray.count != offTimes.count) return;
    if (offStationsArray.count != offFjIdsArray.count) return;
    i = 0;
    for (NSString *offStation in offStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = offStation;
        station.coordinate = [EBTool coordFromString:offLngLats[i]];
        station.time = offTimes[i];
        station.jid = offFjIdsArray[i];
        station.on = NO;
        EBAnnotation *annotation = [[EBAnnotation alloc] init];
        if (i == offStationsArray.count - 1) {
            station.firstOrEnd = YES;
            annotation.imageString = @"search_map_end";
        } else {
            station.firstOrEnd = NO;
            annotation.imageString = @"search_map_endPass";
        }
        annotation.lineInfo = station;
        [dataSource addObject:annotation];
        i ++;
    }
    self.stationView.dataSource = dataSource;
    [self.maMapView addAnnotations:dataSource];
    [self.maMapView showAnnotations:self.maMapView.annotations animated:YES];
}

- (void)addPolylineWithCoords:(NSArray *)coords
{
    if (coords.count == 0) return;
    CLLocationCoordinate2D *coordsC = [self transitToCoords:coords];
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordsC count:coords.count];
    [self.maMapView addOverlay:polyline];
    free(coordsC);
}

- (CLLocationCoordinate2D *)transitToCoords:(NSArray *)coords
{
    int count = (int)coords.count;
    CLLocationCoordinate2D *coordsC = malloc(sizeof(CLLocationCoordinate2D) * count);
    int i = 0;
    for (NSString *obj in coords) {
        NSString *newObj = nil;
        if ([obj hasPrefix:@"!"]) newObj = [obj stringByReplacingOccurrencesOfString:@"!" withString:@""];
        NSArray *objArray = [NSArray seprateString:newObj.length != 0 ? newObj : obj characterSet:@","];
        NSString *lat = [objArray lastObject];
        NSString *lng = [objArray firstObject];
        coordsC[i].latitude = [lat doubleValue];
        coordsC[i].longitude = [lng doubleValue];
        i ++;
    }
    return coordsC;
}

/**
 *  计算经纬度的平均值
 */
- (CLLocationCoordinate2D)averageCoord:(NSArray *)coords {
    double lats = 0;
    double lngs = 0;
    for (NSString *obj in coords) {
        NSString *newObj = nil;
        if ([obj hasPrefix:@"!"]) newObj = [obj stringByReplacingOccurrencesOfString:@"!" withString:@""];
        NSArray *objArray = [NSArray seprateString:newObj.length != 0 ? newObj : obj characterSet:@","];
        NSString *lat = [objArray lastObject];
        NSString *lng = [objArray firstObject];
        lats += [lat doubleValue];
        lngs += [lng doubleValue];
    }
    return CLLocationCoordinate2DMake(lats / coords.count, lngs / coords.count);
}

#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    NSMutableArray *polylines = [NSMutableArray array];
    AMapPath *path = [response.route.paths firstObject];
    [path.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[AMapStep class]]) return;
        AMapStep *step = (AMapStep *)obj;
        MAPolyline *polyline = [CommonUtility polylineForCoordinateString:step.polyline];
        [polylines addObject:polyline];
    }];
    [self.maMapView addOverlays:polylines];
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRender = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRender.strokeColor = EB_LineColor;
        polylineRender.lineWidth = EB_MapLineWidth;
        return polylineRender;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[EBAnnotation class]]) {
        EBAnnotationView *original = [EBAnnotationView annotationViewWithMapView:mapView];
        original.annotation = annotation;
        return original;
    } else if ([annotation isKindOfClass:[EBPPAnnotation class]]) {
        EBLineDetailPPAnnotationView *lineDetail = [EBLineDetailPPAnnotationView annotationViewWithMapView:mapView];
        lineDetail.pp_delegate = self;
        lineDetail.annotation = annotation;
        return lineDetail;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[EBAnnotationView class]]) {
        EBLog(@"didSelect -> EBAnnotationView");
        EBAnnotation *anno = (EBAnnotation *)view.annotation;
        if (anno.isShow) return;
        // 1.删除以前的EBPPAnnotation
        for (id annotation in mapView.annotations) {
            if ([annotation isKindOfClass:[EBAnnotation class]]) {
                EBAnnotation *originalAnno = annotation;
                originalAnno.show = NO;
            } else if ([annotation isKindOfClass:[EBPPAnnotation class]]) {
                [mapView removeAnnotation:annotation];
            }
        }
        anno.show = YES;
        // 2.添加新的EBPPAnnotation
        EBPPAnnotation *pp = [[EBPPAnnotation alloc] init];
        pp.lineInfo = anno.lineInfo;
        [mapView addAnnotation:pp];
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    for (id annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[EBAnnotation class]]) {
            EBAnnotation *originalAnno = annotation;
            originalAnno.show = NO;
        } else if ([annotation isKindOfClass:[EBPPAnnotation class]]) {
            [mapView removeAnnotation:annotation];
        } 
    }

}
#pragma mark - EBLineStationViewDelegate
- (void)lineStationView:(EBLineStationView *)lineStationView didSelectMode:(EBAnnotation *)anno {
    
    // 1.删除以前的EBPPAnnotation
    for (id annotation in self.maMapView.annotations) {
        if ([annotation isKindOfClass:[EBAnnotation class]]) {
            EBAnnotation *originalAnno = annotation;
            originalAnno.show = NO;
        } else if ([annotation isKindOfClass:[EBPPAnnotation class]]) {
            [self.maMapView removeAnnotation:annotation];
        }
    }
    EBPPAnnotation *pp = [[EBPPAnnotation alloc] init];
    pp.lineInfo = anno.lineInfo;
    [self.maMapView addAnnotation:pp];
    [self.maMapView setCenterCoordinate:anno.coordinate animated:YES];
    if (self.leftView.x > EB_MaxWidthOfLineStation / 2) {
        [self leftViewXZero];
    } else {
        [self leftViewXMax];
    }
}
#pragma mark - EBLineDetailPPAnnotationViewDelegate
- (void)lineDetailPPAnnotationViewCheckPhoto:(EBLineDetailPPAnnotationView *)detailV lineDetail:(EBLineStation *)lineM {
    if ([self.delegate respondsToSelector:@selector(lineMapViewCheckPhoto:lineDetail:)]) {
        [self.delegate lineMapViewCheckPhoto:self lineDetail:lineM];
    }
}


#pragma mark - Super Method
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bottomViewImplementation];
        [self leftViewImplementation];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self bottomViewImplementation];
        [self leftViewImplementation];
    }
    return self;
}

- (void)mapViewDidAppear {
    [super mapViewDidAppear];
    self.maMapView.delegate = self;
//    self.maMapView.zoomLevel = 13;
    self.maMapView.showsUserLocation = NO;
}

- (void)mapViewDidDisappear {
    [super mapViewDidDisappear];
    self.maMapView.delegate = nil;
}

- (void)didMoveToSuperview
{
    if(!self.bottomView.hidden) self.bottomDistance = 60;
    [super didMoveToSuperview];
    [self bottomViewAutoLayout];
    [self leftViewAutoLayout];
}

#pragma mark  - Implementation
- (void)bottomViewImplementation {
    UIView *bottom = [[UIView alloc] init];
    bottom.hidden = YES;
    bottom.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    UIButton *buy = [UIButton eb_buttonWithTitle:@"购买"];
    [buy addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:buy];
    [self addSubview:bottom];
    self.bottomView = bottom;
    self.buyBtn = buy;
}

- (void)leftViewImplementation {
    UIView *left = [[UIView alloc] init];
    left.backgroundColor = [UIColor clearColor];
    
    EBLineStationView *stationView = [[EBLineStationView alloc] init];
    stationView.delegate = self;
    [left addSubview:stationView];
    self.stationView = stationView;
    
    UIView *leftDragView = [[UIView alloc] init];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tap.numberOfTapsRequired = 1;
    [leftDragView addGestureRecognizer:pan];
    [leftDragView addGestureRecognizer:tap];
    [left addSubview:leftDragView];
    self.leftDragView = leftDragView;
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.image = [UIImage imageNamed:@"search_drag_right"];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftDragView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.hidden = YES;
    rightImageView.image = [UIImage imageNamed:@"search_drag_left"];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftDragView addSubview:rightImageView];
    self.rightImageView = rightImageView;
    
    [self insertSubview:left belowSubview:self.bottomView];
    self.leftView = left;
}
#pragma mark - autoLayout
- (void)leftViewAutoLayout {
    EB_WS(ws);
    CGFloat stationW = EB_MaxWidthOfLineStation;
    CGFloat leftDragW = 20;
    CGFloat leftViewW = stationW + leftDragW;
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.top.equalTo(ws).with.offset(0);
        make.bottom.equalTo(ws).with.offset(0);
        make.right.equalTo(ws.mas_left).with.offset(leftDragW);
        make.width.mas_equalTo(leftViewW);
    }];
    
    [self lineStationViewAutoLayout:stationW];
    [self leftDragViewAutoLayout:leftDragW];
}

- (void)lineStationViewAutoLayout:(CGFloat)stationW {
    EB_WS(ws);
    [self.stationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.leftView.mas_centerY);
        make.left.equalTo(ws.leftView).with.offset(0);
        make.top.equalTo(ws.leftView).with.offset(0);
        make.bottom.equalTo(ws.leftView).with.offset(0);
        make.width.mas_equalTo(stationW);
    }];
}
- (void)leftDragViewAutoLayout:(CGFloat)leftDragW {
    EB_WS(ws);
    [self.leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.leftView.mas_centerY);
        make.right.equalTo(ws.leftView).with.offset(0);
        make.top.equalTo(ws.leftView).with.offset(0);
        make.bottom.equalTo(ws.leftView).with.offset(0);
        make.width.mas_equalTo(leftDragW);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.leftDragView).with.offset(0);
        make.top.equalTo(ws.leftDragView).with.offset(0);
        make.bottom.equalTo(ws.leftDragView).with.offset(0);
        make.left.equalTo(ws.leftDragView).with.offset(0);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.leftDragView).with.offset(0);
        make.top.equalTo(ws.leftDragView).with.offset(0);
        make.bottom.equalTo(ws.leftDragView).with.offset(0);
        make.left.equalTo(ws.leftDragView).with.offset(0);
    }];
    
}

- (void)bottomViewAutoLayout {
    CGFloat height = 60;
    EB_WS(ws);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.left.equalTo(ws).with.offset(0);
        make.right.equalTo(ws).with.offset(0);
        make.bottom.equalTo(ws).with.offset(0);
        make.height.mas_equalTo(height);//高度
    }];
    
    CGFloat padding1 = 5;
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.bottomView).with.offset(padding1);
        make.bottom.equalTo(ws.bottomView).with.offset(-padding1);
        make.left.equalTo(ws.bottomView).with.offset(padding1 * 6);
        make.right.equalTo(ws.bottomView).with.offset(- padding1 * 6);
    }];
}

#pragma mark - Private Method
- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if (location.x > EB_MaxWidthOfLineStation / 2) {
                _value = YES;
                EBLog(@"YES");
            } else {
                _value = NO;
                EBLog(@"NO");
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (location.x <= EB_MaxWidthOfLineStation) {
                self.leftView.x = - EB_MaxWidthOfLineStation + location.x;
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (_value) {
                if (location.x <= 2 * EB_MaxWidthOfLineStation / 3) {
                    [self leftViewXMax];//消失
                    EBLog(@"消失 leftViewXMax");
                } else {
                    [self leftViewXZero];//出现
                    EBLog(@"出现 leftViewXZero");
                }
            } else {
                if (location.x >= EB_MaxWidthOfLineStation / 3) {
                    [self leftViewXZero];//出现
                    EBLog(@"出现 leftViewXZero");
                } else {
                    [self leftViewXMax];//消失
                    EBLog(@"消失 leftViewXMax");
                }
            }
            break;
        default:
            break;
    }
    
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self];
    if (location.x < EB_MaxWidthOfLineStation / 2) {
        [self leftViewXZero];
    } else {
        [self leftViewXMax];
    }
}
- (void)leftViewXZero {
    [UIView animateWithDuration:0.5f animations:^{
        self.leftView.x = 0;
    } completion:^(BOOL finished) {
        EBLog(@"leftViewXZero finished");
        self.leftImageView.hidden = YES;
        self.rightImageView.hidden = NO;
        self.leftView.x = 0;
    }];
}
- (void)leftViewXMax {
    [UIView animateWithDuration:0.5f animations:^{
        self.leftView.x = - EB_MaxWidthOfLineStation;
    } completion:^(BOOL finished) {
        EBLog(@"leftViewXMax finished");
        self.leftImageView.hidden = NO;
        self.rightImageView.hidden = YES;
        self.leftView.x = - EB_MaxWidthOfLineStation;
    }];
}

- (void)buyBtnClick {
    if ([self.delegate respondsToSelector:@selector(lineMapViewBuyClick:)]) {
        [self.delegate lineMapViewBuyClick:self];
    }
}

@end





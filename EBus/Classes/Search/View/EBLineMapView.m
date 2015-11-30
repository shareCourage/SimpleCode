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
#import "EBLineDetail.h"
#import "EBPhotoAnnotation.h"
#import "EBPhotoAnnotationView.h"
#import "EBLineStationView.h"
#import "EBLineStation.h"
#import "EBSearchResultModel.h"

//高德地图规划线路用的类
#import "CommonUtility.h"

@interface EBLineMapView () <MAMapViewDelegate, AMapSearchDelegate, EBLineStationViewDelegate>
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
- (AMapSearchAPI *)searchPOI {
    if (_searchPOI == nil) {
        _searchPOI = [[AMapSearchAPI alloc] init];
        _searchPOI.delegate = self;
    }
    return _searchPOI;
}

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
    }
    NSUInteger openType = [lineDetailM.openType integerValue];
    [self addAnnotationOnLngLat:lineDetailM.onLngLat onStations:lineDetailM.onStations onFjIds:lineDetailM.onFjIds];
    [self addAnnotationOffLngLat:lineDetailM.offLngLat offStations:lineDetailM.offStations offFjIds:lineDetailM.offFjIds];
    if (openType == 1 || openType == 2) {//购买
        if (lineDetailM.lineContent.length == 0) return;
        [self addOnStations:lineDetailM.onStations offStations:lineDetailM.offStations onLngLat:lineDetailM.onLngLat offLngLat:lineDetailM.offLngLat onTime:lineDetailM.onTimes offTime:lineDetailM.offTimes];
        NSArray *coords = [NSArray seprateString:lineDetailM.lineContent characterSet:@";"];
        [self addPolylineWithCoords:coords];
        [self.maMapView setCenterCoordinate:[self averageCoord:coords] animated:NO];
    } else if (openType == 3) { //跟团
        self.leftView.hidden = YES;
        [self drivingRouteRequest:lineDetailM];
    }
}

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

#pragma mark - init Method
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
    self.maMapView.zoomLevel = 13;
    self.maMapView.showsUserLocation = NO;
}

- (void)mapViewDidDisappear {
    [super mapViewDidDisappear];
    self.maMapView.delegate = nil;
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

#pragma mark - superMethod
- (void)didMoveToSuperview
{
    if(!self.bottomView.hidden) self.bottomDistance = 60;
    [super didMoveToSuperview];
    [self bottomViewAutoLayout];
    [self leftViewAutoLayout];
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

- (void)addOnStations:(NSString *)onStations
          offStations:(NSString *)offStations
             onLngLat:(NSString *)onLngLat
            offLngLat:(NSString *)offLngLat
              onTime:(NSString *)onTime
             offTime:(NSString *)offTime {
    NSMutableArray *dataSource = [NSMutableArray array];
    NSArray *onStationsArray = [onStations componentsSeparatedByString:@";"];
    NSArray *onLngLats = [onLngLat componentsSeparatedByString:@";"];
    NSArray *onTimes = [onTime componentsSeparatedByString:@";"];
    if (onStationsArray.count != onLngLats.count) return;
    if (onStationsArray.count != onTimes.count) return;
    int i = 0;
    for (NSString *onStation in onStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = onStation;
        station.lnglat = onLngLats[i];
        station.time = onTimes[i];
        station.on = YES;
        if (i == 0) station.firstOrEnd = YES;
        i ++;
        [dataSource addObject:station];
    }
    i = 0;
    NSArray *offStationsArray = [offStations componentsSeparatedByString:@";"];
    NSArray *offLngLats = [offLngLat componentsSeparatedByString:@";"];
    NSArray *offTimes = [offTime componentsSeparatedByString:@";"];
    if (offStationsArray.count != offLngLats.count) return;
    if (offStationsArray.count != offTimes.count) return;
    for (NSString *offStation in offStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = offStation;
        station.lnglat = offLngLats[i];
        station.time = offTimes[i];
        station.on = NO;
        if (i == offStationsArray.count - 1) station.firstOrEnd = YES;
        i ++;
        [dataSource addObject:station];
    }
    self.stationView.dataSource = dataSource;
}
- (void)addAnnotationOnLngLat:(NSString *)onLngLat onStations:(NSString *)onStations onFjIds:(NSString *)onFjIds {
    NSArray *onLngLatArray = [NSArray seprateString:onLngLat characterSet:@";"];
    NSArray *onStationsArray = [onStations componentsSeparatedByString:@";"];//[NSArray seprateString:onStations characterSet:@";"];
    NSArray *onFjIdsArray = [NSArray seprateString:onFjIds characterSet:@";"];
    if (onLngLatArray.count != onStationsArray.count) return;
    for (int i = 0; i < onLngLatArray.count; i ++) {
        EBAnnotation *annotation = [[EBAnnotation alloc] init];
        NSString *onLngLat = onLngLatArray[i];
        NSString *onStation = onStationsArray[i];
        NSString *onJid = onFjIdsArray[i];
        if (i == 0) {
            annotation.imageString = @"search_map_depart";
        } else {
            annotation.imageString = @"search_map_departPass";
        }
        annotation.coordinate = [onLngLat coordAndLatFirst:NO];
        annotation.lineInfo.station = onStation;
        annotation.lineInfo.time = self.resultModel.startTime;
        annotation.lineInfo.jid = onJid;
        annotation.lineInfo.coordinate = annotation.coordinate;
        [self.maMapView addAnnotation:annotation];
    }
}

- (void)addAnnotationOffLngLat:(NSString *)offLngLat offStations:(NSString *)offStations offFjIds:(NSString *)offFjIds {
    NSArray *offLngLatArray = [NSArray seprateString:offLngLat characterSet:@";"];
    NSArray *offStationsArray = [offStations componentsSeparatedByString:@";"];//[NSArray seprateString:offStations characterSet:@";"];
    NSArray *offFjIdsArray = [NSArray seprateString:offFjIds characterSet:@";"];
    if (offLngLatArray.count != offStationsArray.count) return;
    NSUInteger count = offLngLatArray.count;
    for (int i = (int)count - 1; i >= 0; i --) {
        EBAnnotation *annotation = [[EBAnnotation alloc] init];
        NSString *offLngLat = offLngLatArray[i];
        NSString *offStation = offStationsArray[i];
        NSString *offJid = offFjIdsArray[i];
        if (i == count - 1) {
            annotation.imageString = @"search_map_end";
        } else {
            annotation.imageString = @"search_map_endPass";
        }
        annotation.coordinate = [offLngLat coordAndLatFirst:NO];
        annotation.lineInfo.station = offStation;
        annotation.lineInfo.time = self.resultModel.startTime;
        annotation.lineInfo.jid = offJid;
        annotation.lineInfo.coordinate = annotation.coordinate;
        [self.maMapView addAnnotation:annotation];
    }
    
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
        polylineRender.lineWidth = 4.0;
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
        lineDetail.annotation = annotation;
        return lineDetail;
    } else if ([annotation isKindOfClass:[EBPhotoAnnotation class]]) {
        EBPhotoAnnotationView *photo = [EBPhotoAnnotationView annotationViewWithMapView:mapView];
        photo.annotation = annotation;
        [mapView setCenterCoordinate:annotation.coordinate animated:YES];
        return photo;
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
    } else if ([view isKindOfClass:[EBLineDetailPPAnnotationView class]]) {
        EBLog(@"didSelect -> EBLineDetailPPAnnotationView");
        for (id annotation in mapView.annotations) {
            if ([annotation isKindOfClass:[EBAnnotation class]]) {
                EBAnnotation *originalAnno = annotation;
                originalAnno.show = NO;
            }
        }
        EBPPAnnotation *anno = (EBPPAnnotation *)view.annotation;
        EBPhotoAnnotation *photoAnno = [[EBPhotoAnnotation alloc] init];
        photoAnno.lineInfo = anno.lineInfo;
        [mapView removeAnnotation:anno];
        [mapView addAnnotation:photoAnno];

    } else if ([view isKindOfClass:[EBPhotoAnnotationView class]]) {
        [mapView removeAnnotation:view.annotation];
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    for (id annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[EBAnnotation class]]) {
            EBAnnotation *originalAnno = annotation;
            originalAnno.show = NO;
        } else if ([annotation isKindOfClass:[EBPPAnnotation class]]) {
            [mapView removeAnnotation:annotation];
        } else if ([annotation isKindOfClass:[EBPhotoAnnotation class]]) {
            [mapView removeAnnotation:annotation];
        }
    }

}
#pragma mark - EBLineStationViewDelegate
- (void)lineStationView:(EBLineStationView *)lineStationView didSelectMode:(EBLineStation *)lineStation {
    NSArray *lnglats = [lineStation.lnglat componentsSeparatedByString:@","];
    NSString *lng = [lnglats firstObject];
    NSString *lat = [lnglats lastObject];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    [self.maMapView setCenterCoordinate:coord animated:YES];
    if (self.leftView.x > EB_MaxWidthOfLineStation / 2) {
        [self leftViewXZero];
    } else {
        [self leftViewXMax];
    }
}

@end





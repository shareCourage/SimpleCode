//
//  EBLineMapView.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_LineColor EB_RGBColor(90, 138, 251)
#define EB_MaxWidthOfLineStation (EB_WidthOfScreen / 2 + 50) //左边滑动的view的最大宽度值
#import "EBLineMapView.h"
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

@interface EBLineMapView () <MAMapViewDelegate>

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *buyBtn;
@property (nonatomic, weak) UIImageView *leftDragView;
@property (nonatomic, weak) EBLineStationView *stationView;
@end

@implementation EBLineMapView

- (void)setResultModel:(EBSearchResultModel *)resultModel {
    _resultModel = resultModel;
    if ([resultModel.openType integerValue] == 1) {
        [self.buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    } else if ([resultModel.openType integerValue] == 2) {
        [self.buyBtn setTitle:@"报名" forState:UIControlStateNormal];
    }
}

#pragma mark - init Method
//保证代码实例化能创建BMKMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maMapView.delegate = self;
        [self bottomViewImplementation];
        [self leftDragViewImplementation];
        [self lineStationViewImplementation];
    }
    return self;
}
//保证xib实例化能创建BMKMapView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.maMapView.delegate = self;
        [self bottomViewImplementation];
        [self leftDragViewImplementation];
        [self lineStationViewImplementation];
    }
    return self;
}
#pragma mark  - Implementation
- (void)bottomViewImplementation {
    UIView *bottom = [[UIView alloc] init];
    bottom.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
    [buy setTitle:@"购买" forState:UIControlStateNormal];
    buy.titleLabel.font = [UIFont systemFontOfSize:20];
    [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buy setBackgroundColor:EB_RGBColor(157, 197, 236)];
    buy.layer.cornerRadius = 25;
    [buy addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:buy];
    [self addSubview:bottom];
    self.bottomView = bottom;
    self.buyBtn = buy;
}
- (void)leftDragViewImplementation {
    UIImageView *leftDrag = [[UIImageView alloc] init];
    leftDrag.contentMode = UIViewContentModeScaleAspectFill;
    leftDrag.userInteractionEnabled = YES;
    leftDrag.image = [UIImage imageNamed:@"search_drag_right"];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [leftDrag addGestureRecognizer:pan];
    [leftDrag addGestureRecognizer:tap];
    [self addSubview:leftDrag];
    self.leftDragView = leftDrag;
}
- (void)lineStationViewImplementation {
    EBLineStationView *stationView = [[EBLineStationView alloc] init];
    stationView.backgroundColor = EB_RGBColor(250, 254, 246);
    [self insertSubview:stationView belowSubview:self.bottomView];
    self.stationView = stationView;
}
#pragma mark - autoLayout
- (void)lineStationViewAutoLayout {
    EB_WS(ws);
    [self.stationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.equalTo(ws).with.offset(0);
        make.top.equalTo(ws).with.offset(0);
        make.bottom.equalTo(ws).with.offset(0);
        make.width.mas_equalTo(0);
    }];
}
- (void)leftDragViewAutoLayout {
    EB_WS(ws);
    CGFloat width = 20;
    CGFloat height = 50;
    [self.leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.equalTo(ws).with.offset(0);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
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
    self.bottomDistance = 60;
    [super didMoveToSuperview];
    [self bottomViewAutoLayout];
    [self leftDragViewAutoLayout];
    [self lineStationViewAutoLayout];
}

- (void)mapViewDidAppear {
    [super mapViewDidAppear];
    self.maMapView.zoomLevel = 13;
}

- (void)mapViewDidDisappear {
    [super mapViewDidDisappear];
}

- (void)setLineDetailM:(EBLineDetailModel *)lineDetailM {
    _lineDetailM = lineDetailM;
    if (lineDetailM.lineContent.length == 0) return;
    [self addAnnotationOnLngLat:lineDetailM.onLngLat onStations:lineDetailM.onStations onFjIds:lineDetailM.onFjIds];
    [self addAnnotationOffLngLat:lineDetailM.offLngLat offStations:lineDetailM.offStations offFjIds:lineDetailM.offFjIds];
    [self addOnStations:lineDetailM.onStations offStations:lineDetailM.offStations];
    NSArray *coords = [NSArray seprateString:lineDetailM.lineContent characterSet:@";"];
    [self addPolylineWithCoords:coords];
    [self.maMapView setCenterCoordinate:[self averageCoord:coords] animated:NO];
}

#pragma mark - Private Method
- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
//    CGFloat panX = [pan translationInView:self].x;
    CGPoint location = [pan locationInView:self];
    EBLog(@"%@",NSStringFromCGPoint(location));
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            EBLog(@"UIGestureRecognizerStateBegan");
            break;
        case UIGestureRecognizerStateChanged:
            EBLog(@"UIGestureRecognizerStateChanged");
            
            break;
        case UIGestureRecognizerStateEnded:
            EBLog(@"UIGestureRecognizerStateEnded");
            if (location.x > EB_MaxWidthOfLineStation / 2) {
                [UIView animateWithDuration:0.3f animations:^{
                    self.stationView.width = EB_MaxWidthOfLineStation - 10;
                } completion:^(BOOL finished) {
                    self.stationView.width = EB_MaxWidthOfLineStation - 10;
                    self.leftDragView.image = [UIImage imageNamed:@"search_drag_left"];
                }];
            }
            break;
        default:
            break;
    }
    if (location.x <= EB_MaxWidthOfLineStation) {
        self.leftDragView.image = [UIImage imageNamed:@"search_drag_right"];
        self.leftDragView.centerX = location.x;
        if (self.leftDragView.x < 0) self.leftDragView.x = 0;
        if (location.x >= 10) {
            self.stationView.width = location.x - 10;
        } else {
            self.stationView.width = 0;
        }
    } else {
        self.leftDragView.image = [UIImage imageNamed:@"search_drag_left"];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tap {
    
}

- (void)buyBtnClick {
    if ([self.delegate respondsToSelector:@selector(lineMapViewBuyClick:)]) {
        [self.delegate lineMapViewBuyClick:self];
    }
}

- (void)addOnStations:(NSString *)onStations offStations:(NSString *)offStations {
    NSMutableArray *dataSource = [NSMutableArray array];
    NSArray *onStationsArray = [onStations componentsSeparatedByString:@";"];
    int i = 0;
    for (NSString *onStation in onStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = onStation;
        station.on = YES;
        if (i == 0) station.firstOrEnd = YES;
        i ++;
        [dataSource addObject:station];
    }
    i = 0;
    NSArray *offStationsArray = [offStations componentsSeparatedByString:@";"];
    for (NSString *offStation in offStationsArray) {
        EBLineStation *station = [[EBLineStation alloc] init];
        station.station = offStation;
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
}

- (void)addPolylineWithCoords:(NSArray *)coords
{
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

        EBAnnotation *anno = view.annotation;
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
        EBPPAnnotation *anno = view.annotation;
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


@end





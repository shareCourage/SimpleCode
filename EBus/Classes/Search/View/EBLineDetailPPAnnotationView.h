//
//  EBLineDetailPPAnnotationView.h
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
// 线路详情泡泡AnnotationView

#import <MAMapKit/MAMapKit.h>
@class EBLineDetailPPAnnotationView, EBLineStation;

@protocol EBLineDetailPPAnnotationViewDelegate <NSObject>

@optional
- (void)lineDetailPPAnnotationViewCheckPhoto:(EBLineDetailPPAnnotationView *)detailV lineDetail:(EBLineStation *)lineM;

@end

@interface EBLineDetailPPAnnotationView : MAAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;

@property (nonatomic, assign) id <EBLineDetailPPAnnotationViewDelegate>pp_delegate;//为了防止跟其他代理命名冲突

@end

//
//  EBSysMapView.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_ImageName_MinusBtn    @"map_minus"
#define EB_ImageName_PlusBtn     @"map_plus"
#import "EBSysMapView.h"

@interface EBSysMapView ()

@property (nonatomic, weak) UIView *scaleView;
@property (nonatomic, weak) UIButton *minusBtn;//缩小地图
@property (nonatomic, weak) UIButton *plusBtn;//放大地图

@end

@implementation EBSysMapView

- (void)mapViewDidAppear {};
- (void)mapViewDidDisappear {};

#pragma mark - init Method
//保证代码实例化能创建BMKMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mapViewInstantiation];
        [self addMinusAndPlusButton];
    }
    return self;
}
//保证xib实例化能创建BMKMapView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self mapViewInstantiation];
        [self addMinusAndPlusButton];
    }
    return self;
}
#pragma mark - 添加子控件
//bmkMapView的实例化和基本的设置
- (void)mapViewInstantiation
{
    MAMapView *mapView = [[MAMapView alloc] init];
    mapView.mapType = MAMapTypeStandard;
    [self addSubview:mapView];
    self.maMapView = mapView;
}

//在自身添加子控件Minus 和 Plus
- (void)addMinusAndPlusButton
{
    UIView *scale = [[UIView alloc] init];
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *plus  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [minus setBackgroundImage:[UIImage imageNamed:EB_ImageName_MinusBtn] forState:UIControlStateNormal];
    [plus  setBackgroundImage:[UIImage imageNamed:EB_ImageName_PlusBtn] forState:UIControlStateNormal];
    [minus addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [plus  addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [scale addSubview:plus];
    [scale addSubview:minus];
    [self addSubview:scale];
    self.minusBtn = minus;
    self.plusBtn = plus;
    self.scaleView = scale;
}


#pragma mark - Button的响应方法
- (void)minusBtnClick{
    CGFloat level = self.maMapView.zoomLevel;
    level --;
    [self.maMapView setZoomLevel:level animated:YES];
}
- (void)plusBtnClick{
    CGFloat level = self.maMapView.zoomLevel;
    level ++;
    [self.maMapView setZoomLevel:level animated:YES];
}


#pragma mark - 使用autoLayout设定子控件的frame
//self添加子控件的时候，设置frame
- (void)didMoveToSuperview
{
    //    PHLog(@"didMoveToSuperview");
    [self setBmkMapViewFrameUsingAutoLayout];
    [self setMinusAndPlusFrameUsingAutoLayout];
}
//使用autoLayout设置BmkMapView的frame
- (void)setBmkMapViewFrameUsingAutoLayout
{
    EB_WS(ws);
    [self.maMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).with.offset(0);
        make.left.equalTo(ws).with.offset(0);
        make.bottom.equalTo(ws).with.offset(0);
        make.right.equalTo(ws).with.offset(0);
    }];
}
//使用autoLayout设置两个Minus 和 Plus的frame
- (void)setMinusAndPlusFrameUsingAutoLayout
{
    EB_WS(ws);
    CGFloat padding = 10.0f;
    CGFloat bottom = 15.0f;
    CGFloat heightBtn = 40.0f;
    CGFloat widthBtn = 35.0f;
    
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn * 2));
        make.width.mas_equalTo(@(widthBtn));
        make.right.equalTo(ws.mas_right).with.offset(- padding);
        make.bottom.equalTo(ws.mas_bottom).with.offset(- bottom - ws.bottomDistance);
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.scaleView.mas_centerX);
        make.bottom.equalTo(ws.scaleView).with.offset(0);
        make.left.equalTo(ws.scaleView).with.offset(0);
        make.right.equalTo(ws.scaleView).with.offset(0);
        make.height.mas_equalTo(@(heightBtn));//高度
    }];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.scaleView.mas_centerX);
        make.top.equalTo(ws.scaleView).with.offset(0);
        make.left.equalTo(ws.scaleView).with.offset(0);
        make.right.equalTo(ws.scaleView).with.offset(0);
        make.height.mas_equalTo(@(heightBtn));//高度
    }];
}

@end

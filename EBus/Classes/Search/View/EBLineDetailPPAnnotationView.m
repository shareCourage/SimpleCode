//
//  EBLineDetailPPAnnotationView.m
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineDetailPPAnnotationView.h"
#import "EBLineDetailPPView.h"
#import "EBPPAnnotation.h"

@interface EBLineDetailPPAnnotationView () <EBLineDetailPPViewDelegate>

@property (nonatomic, weak)EBLineDetailPPView *ppView;

@end

@implementation EBLineDetailPPAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    NSString *ID = NSStringFromClass([self class]);
    // 从缓存池中取出可以循环利用的大头针view
    EBLineDetailPPAnnotationView *annoView = (EBLineDetailPPAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[self alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    annoView.layer.anchorPoint = CGPointMake(0.615, 1);
    return annoView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        EBLineDetailPPView *lineDetailPPView = [EBLineDetailPPView lineDetailPPView];
        lineDetailPPView.delegate = self;
//        lineDetailPPView.userInteractionEnabled = NO;
        lineDetailPPView.y = 50;
        [self addSubview:lineDetailPPView];
        self.ppView = lineDetailPPView;
        self.frame = CGRectMake(0, 0, 200, 100);
        lineDetailPPView.frame = CGRectMake(0, -12, 200, 100);
    }
    return self;
}


- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    EBPPAnnotation *ppAnno = annotation;
    self.ppView.lineDetail = ppAnno.lineInfo;
}

/**
 *  当一个view被添加到父控件中,就会调用
 */
- (void)didMoveToSuperview
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.values = @[@0, @1.5, @1];
    anim.duration = 0.3;
    [self.layer addAnimation:anim forKey:nil];
}

#pragma mark - EBLineDetailPPViewDelegate
- (void)lineDetailPPViewCheckPhoto:(EBLineDetailPPView *)ppView lineDetail:(EBLineStation *)lineM{
    if ([self.pp_delegate respondsToSelector:@selector(lineDetailPPAnnotationViewCheckPhoto:lineDetail:)]) {
        [self.pp_delegate lineDetailPPAnnotationViewCheckPhoto:self lineDetail:lineM];
    }
}

@end






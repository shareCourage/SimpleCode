//
//  EBAnnotationView.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAnnotationView.h"
#import "EBAnnotation.h"

@interface EBAnnotationView ()

@end

@implementation EBAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    NSString *ID = NSStringFromClass([self class]);
    // 从缓存池中取出可以循环利用的大头针view
    EBAnnotationView *annoView = (EBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[self alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    
    return annoView;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    if ([annotation isKindOfClass:[EBAnnotation class]]) {
        EBAnnotation *ebAnn = annotation;
        self.image = [UIImage imageNamed:ebAnn.imageString];
    }
    
}

@end

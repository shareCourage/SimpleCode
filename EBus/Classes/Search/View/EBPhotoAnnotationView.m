//
//  EBPhotoAnnotationView.m
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBPhotoAnnotationView.h"
#import "EBPhotoAnnotation.h"
#import "EBLineDetail.h"
#import <UIImageView+WebCache.h>

@interface EBPhotoAnnotationView ()

@property (nonatomic, weak) UIImageView *photoView;

@end

@implementation EBPhotoAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    NSString *ID = NSStringFromClass([self class]);
    // 从缓存池中取出可以循环利用的大头针view
    EBPhotoAnnotationView *annoView = (EBPhotoAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[self alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
//        photoView.backgroundColor = [UIColor redColor];
        [self addSubview:photoView];
        self.photoView = photoView;
        
        if (EB_WidthOfScreen <= 320) {
            self.frame = CGRectMake(0, 0, 300, 150);
        } else {
            self.frame = CGRectMake(0, 0, 350, 175);
        }
        photoView.frame = self.bounds;
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    EBPhotoAnnotation *photoAnno = annotation;
    EB_WS(ws);
    if (photoAnno.lineInfo.jid.length == 0) return;
    [EBNetworkRequest GET:static_Url_LinePhoto parameters:@{static_Argument_bcStationId : photoAnno.lineInfo.jid} dictBlock:^(NSDictionary *dict) {
        NSString *urlStr = dict[static_Argument_returnData];
        if (urlStr.length == 0) return;
        [ws.photoView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"search_checkPhoto"]];
    } errorBlock:nil];
}




@end

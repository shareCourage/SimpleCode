//
//  EBSysMapView.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <Masonry/Masonry.h>
#import "EBUserInfo.h"

@interface EBSysMapView : UIView

@property (nonatomic, weak) MAMapView *maMapView;
@property (nonatomic, assign) CGFloat bottomDistance;//放大缩小图标距离底部的距离

- (void)mapViewDidAppear;
- (void)mapViewDidDisappear;

@end

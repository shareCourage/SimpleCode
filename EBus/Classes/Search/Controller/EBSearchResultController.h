//
//  EBSearchResultController.h
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
@class EBHotLabel;

@interface EBSearchResultController : PHViewController

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;//正常查询传递的经纬度
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;

@property (nonatomic, strong) EBHotLabel *hotLabel;//从热门标签传递过来的模型
@end

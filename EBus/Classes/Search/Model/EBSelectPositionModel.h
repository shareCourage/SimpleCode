//
//  EBSelectPositionModel.h
//  EBus
//
//  Created by Kowloon on 15/10/17.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMapPOI;
@class AMapReGeocode;

@interface EBSelectPositionModel : NSObject

@property (nonatomic, strong) AMapPOI *poi;//通过POI搜索出来的地址
@property (nonatomic, strong) AMapReGeocode *regeocode;//逆地址解析地址
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end

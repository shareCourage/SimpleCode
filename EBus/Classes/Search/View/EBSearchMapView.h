//
//  EBSearchMapView.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSysMapView.h"
#import <AMapSearchKit/AMapSearchKit.h>
@class EBSearchMapView;

@protocol EBSearchMapViewDelegate <NSObject>

@optional
- (void)searchMapView:(EBSearchMapView *)searchMapView poiSearch:(NSArray *)places;
- (void)searchMapView:(EBSearchMapView *)searchMapView locationReGeocode:(AMapReGeocode *)reGeocode location:(CLLocation *)location;

@end

@interface EBSearchMapView : EBSysMapView

@property (nonatomic, weak) IBOutlet id <EBSearchMapViewDelegate> delegate;

@end

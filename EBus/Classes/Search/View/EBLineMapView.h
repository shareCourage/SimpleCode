//
//  EBLineMapView.h
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSysMapView.h"
@class EBLineDetailModel, EBLineMapView, EBSearchResultModel;

@protocol EBLineMapViewDelegate <NSObject>

@optional
- (void)lineMapViewBuyClick:(EBLineMapView *)lineMapView;

@end

@interface EBLineMapView : EBSysMapView

@property (nonatomic, strong) EBLineDetailModel *lineDetailM;
@property (nonatomic, strong) EBSearchResultModel *resultModel;

@property (nonatomic, weak) IBOutlet id <EBLineMapViewDelegate>delegate;

@end

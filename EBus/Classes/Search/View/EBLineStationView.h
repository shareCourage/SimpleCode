//
//  EBLineStationView.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBLineStationView, EBAnnotation;

@protocol EBLineStationViewDelegate <NSObject>

@optional
- (void)lineStationView:(EBLineStationView *)lineStationView didSelectMode:(EBAnnotation *)anno;

@end


@interface EBLineStationView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) id <EBLineStationViewDelegate>delegate;

@end

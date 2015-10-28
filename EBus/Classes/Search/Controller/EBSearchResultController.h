//
//  EBSearchResultController.h
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTableViewController.h"
@class EBHotLabel;

@interface EBSearchResultController : PHTableViewController

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;

@property (nonatomic, strong) EBHotLabel *hotLabel;
@end

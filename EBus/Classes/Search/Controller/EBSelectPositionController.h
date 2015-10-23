//
//  EBSelectPositionController.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
@class EBSelectedAnnotation;

@interface EBSelectPositionController : PHViewController

- (instancetype)initWithOption:(void (^)(NSString *title, CLLocationCoordinate2D coord))option;

@end

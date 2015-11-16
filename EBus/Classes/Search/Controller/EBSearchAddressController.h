//
//  EBSearchAddressController.h
//  EBus
//
//  Created by Kowloon on 15/11/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
@class AMapPOI;

@interface EBSearchAddressController : PHViewController

- (instancetype)initWithOption:(void (^)(AMapPOI *poi))option;


@end

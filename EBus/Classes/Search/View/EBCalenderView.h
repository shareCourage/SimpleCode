//
//  EBCalenderView.h
//  EBus
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHCalenderKit.h"

@interface EBCalenderView : UIView

@property (nonatomic, strong) NSDictionary *priceAndTicket;
- (void)reloadData;

@end

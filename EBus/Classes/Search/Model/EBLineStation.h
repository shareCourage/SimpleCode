//
//  EBLineStation.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBLineStation : NSObject

@property (nonatomic, assign, getter = isOn) BOOL on;
@property (nonatomic, assign, getter = isFirstOrEnd) BOOL firstOrEnd;
@property (nonatomic, copy) NSString *station;

@end

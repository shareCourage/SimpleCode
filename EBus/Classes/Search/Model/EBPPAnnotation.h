//
//  EBPPAnnotation.h
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class EBLineDetail;

@interface EBPPAnnotation : NSObject <MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) EBLineDetail *lineInfo;

@end

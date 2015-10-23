//
//  EBAnnotation.h
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class EBLineDetail;

@interface EBAnnotation : NSObject <MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *imageString;
@property (nonatomic, assign, getter = isShow) BOOL show;

@property (nonatomic, strong) EBLineDetail *lineInfo;

@end

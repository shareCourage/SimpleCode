//
//  EBAnnotation.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAnnotation.h"
#import "EBLineStation.h"

@implementation EBAnnotation
@synthesize lineInfo = _lineInfo;


- (void)setLineInfo:(EBLineStation *)lineInfo {
    _lineInfo = lineInfo;
    self.coordinate = lineInfo.coordinate;
}

@end

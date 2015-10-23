//
//  EBAnnotation.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAnnotation.h"
#import "EBLineDetail.h"

@implementation EBAnnotation


- (EBLineDetail *)lineInfo {
    if (!_lineInfo) {
        _lineInfo = [[EBLineDetail alloc] init];
    }
    return _lineInfo;
}

@end

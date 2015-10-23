//
//  EBPhotoAnnotation.m
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBPhotoAnnotation.h"
#import "EBLineDetail.h"

@implementation EBPhotoAnnotation

- (void)setLineInfo:(EBLineDetail *)lineInfo {
    _lineInfo = lineInfo;
    self.coordinate = lineInfo.coordinate;
}

@end

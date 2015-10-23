//
//  UIProgressView+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UIProgressView+PHCategory.h"

@implementation UIProgressView (PHCategory)

- (void)setTheProgress:(float)progress animated:(BOOL)animated{
    if (EB_iOS7) {
        [self setProgress:progress animated:animated];
    }else {
        self.progress = progress;
    }
}

@end

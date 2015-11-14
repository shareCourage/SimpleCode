//
//  EBSPButton.m
//  EBus
//
//  Created by Kowloon on 15/11/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSPButton.h"

@implementation EBSPButton
- (instancetype)initWithTitle:(NSString *)title withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = 50;
    CGFloat imageX = contentRect.size.width - 50;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat padding = 10;
    CGFloat titleY = 5;
    CGFloat titleX = padding;
    CGFloat titleW = contentRect.size.width - 50;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

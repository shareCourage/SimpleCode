//
//  EBPayTypeButton.m
//  EBus
//
//  Created by Kowloon on 15/11/2.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define padding 80
#import "EBPayTypeButton.h"

@implementation EBPayTypeButton



- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.height;
    CGFloat imageX = contentRect.size.width / 2 - padding;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = contentRect.size.width / 2 - padding + titleH - 7;
    CGFloat titleW = contentRect.size.width / 2 + padding;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

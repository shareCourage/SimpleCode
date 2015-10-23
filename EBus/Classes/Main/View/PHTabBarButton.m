//
//  PHTabBarButton.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTabBarButton.h"

@implementation PHTabBarButton

/**
 *  覆盖了这个方法,按钮就不存在高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted
{
//    [super setHighlighted:highlighted];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 5;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.6;
    return CGRectMake(0, imageY, imageW, imageH);
 
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height *0.6 + 5;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}
@end

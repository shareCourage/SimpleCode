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
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat padding = 5;
    CGFloat imageY = padding;
    CGFloat imageH = contentRect.size.height - padding * 2;
    CGFloat imageW = imageH;
    CGFloat imageX = contentRect.size.width - imageW - 2 * padding;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat padding = 10;
    CGFloat titleY = 0;
    CGFloat titleX = padding;
    CGFloat titleW = contentRect.size.width - 50;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

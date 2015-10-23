//
//  EBSearchBusButton.m
//  EBus
//
//  Created by Kowloon on 15/10/14.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_imageWithOfSearchBusButton 10
#import "EBSearchBusButton.h"


@implementation EBSearchBusButton

- (void)dealloc
{
    EBLog(@"%@ ->dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithTitle:(NSString *)title withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:EB_RGBColor(199, 204, 215) forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


+ (instancetype)searchBusButtonWithTitle:(NSString *)title withFrame:(CGRect)frame
{
    EBSearchBusButton *button = [[self alloc] initWithTitle:title withFrame:frame];
    button.frame = frame;
    return button;
}

+ (instancetype)searchBusButtonWithTitle:(NSString *)title
{
    return [self searchBusButtonWithTitle:title withFrame:CGRectZero];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = EB_imageWithOfSearchBusButton;
    CGFloat imageX = contentRect.size.height / 2 - imageW / 2;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat padding = 10;
    CGFloat titleY = 0;
    CGFloat titleX = contentRect.size.height / 2 + EB_imageWithOfSearchBusButton / 2 + padding;
    CGFloat titleW = contentRect.size.width - 10;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end




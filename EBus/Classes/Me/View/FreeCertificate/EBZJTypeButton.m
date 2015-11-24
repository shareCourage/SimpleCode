//
//  EBZJTypeButton.m
//  EBus
//
//  Created by Kowloon on 15/11/12.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBZJTypeButton.h"

@implementation EBZJTypeButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self imageSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self imageSetting];
    }
    return self;
}

- (void)imageSetting {
    self.adjustsImageWhenHighlighted = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *down = [UIImage imageNamed:@"me_freeCert_zjTypeDown"];
    UIImage *up = [UIImage imageNamed:@"me_freeCert_zjTypeUp"];
    [self setImage:down forState:UIControlStateNormal];
    [self setImage:up forState:UIControlStateSelected];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = 20;
    CGFloat imageX = contentRect.size.width - imageW * 1.6f;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


@end

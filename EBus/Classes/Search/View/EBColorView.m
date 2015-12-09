//
//  EBColorView.m
//  EBus
//
//  Created by Kowloon on 15/10/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBColorView.h"

@implementation EBColorView


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width / self.subviews.count;
    CGFloat height = self.frame.size.height;
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        CGFloat backX = i * width;
        CGFloat backY = 0;
        CGRect backF = CGRectMake(backX, backY, width, height);
        UIView *backV = self.subviews[i];
        backV.frame = backF;
        
        UIView *colorV = backV.subviews[0];
        UILabel *wordL = backV.subviews[1];
        
        CGFloat colorH = height;
        CGFloat colorW = 25;
        CGFloat wordH = height;
        CGFloat wordW = [wordL boundingRectWithSize:CGSizeMake(MAXFLOAT, wordH)].width;
        colorV.size = CGSizeMake(colorW, colorH);
        wordL.size =  CGSizeMake(wordW, wordH);
        CGFloat colorY = 0;
        CGFloat colorX = 20;
        CGFloat wordY = 0;
        CGFloat totalW = colorX + colorW + wordW;
        if (wordW < width) {
            if (totalW > width) {
                while (1) {
                    colorX --;
                    if (colorX < 0) break;
                    totalW = colorX + colorW + wordW;
                    if (totalW < width) {
                        break;
                    }
                }
            }
        } 
        CGFloat wordX = colorX + colorW;
        CGRect wordFrame = CGRectMake(wordX, wordY, wordW, wordH);
        CGRect colorFrame = CGRectMake(colorX, colorY, colorW, colorH);
        colorV.frame = colorFrame;
        wordL.frame = wordFrame;
    }
}

- (void)addSubViewTitles:(NSArray *)titles colors:(NSArray *)colors {
    if (titles.count != colors.count && titles.count <= 1) return;
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIView *backV = [self backViewWithTitle:titles[i] color:colors[i]];
        [self addSubview:backV];
    }
}

- (UIView *)backViewWithTitle:(NSString *)title color:(UIColor *)color {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor clearColor];
    UIView *colorV = [[UIView alloc] init];
    colorV.backgroundColor = color;
    colorV.layer.borderColor = color.CGColor;
    colorV.layer.borderWidth = 1.f;
    if ([EBTool isTheSameColor1:color anotherColor:[UIColor whiteColor]]) {
        colorV.layer.borderColor = EB_RGBColor(241, 241, 241).CGColor;
    }
    UILabel *wordL = [[UILabel alloc] init];
    wordL.font = [UIFont systemFontOfSize:13];
    wordL.text = title;
    [backV insertSubview:colorV atIndex:0];
    [backV insertSubview:wordL atIndex:1];
    return backV;
}


@end








//
//  UIButton+EBButton.m
//  EBus
//
//  Created by Kowloon on 15/11/7.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "UIButton+EBButton.h"

@implementation UIButton (EBButton)

+ (instancetype)eb_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action Title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:EB_RGBColor(157, 197, 236)];
    CGFloat height = frame.size.height;
    button.layer.cornerRadius = height / 2;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    return button;
}

+ (instancetype)eb_buttonWithTitle:(NSString *)title {
    UIButton *button = [self eb_buttonWithFrame:CGRectZero target:nil action:nil Title:title];
    button.layer.cornerRadius = 25;
    return button;
}
@end

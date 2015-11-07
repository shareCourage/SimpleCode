//
//  UIButton+EBButton.m
//  EBus
//
//  Created by Kowloon on 15/11/7.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "UIButton+EBButton.h"

@implementation UIButton (EBButton)
+ (instancetype)eb_buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:EB_RGBColor(157, 197, 236)];
    button.layer.cornerRadius = 25;
    return button;
}
@end

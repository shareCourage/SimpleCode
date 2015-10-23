//
//  UIButton+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UIButton+PHCategory.h"

@implementation UIButton (PHCategory)
+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                  normalImage:(UIImage *)imageN
                selectedImage:(UIImage *)imageS
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, imageN.size.width, imageN.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageS forState:UIControlStateSelected];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                  normalImage:(UIImage *)imageN
                        title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithFrame:frame target:target action:action normalImage:imageN selectedImage:nil];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
@end

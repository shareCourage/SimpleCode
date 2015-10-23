//
//  UISlider+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UISlider+PHCategory.h"

@implementation UISlider (PHCategory)
+ (UISlider *)sliderWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                   thumbImage:(NSString *)thumbImageName
                   thumbState:(UIControlState)thumbState
                 controlEvent:(UIControlEvents)event

{
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider setThumbImage:[UIImage imageNamed:thumbImageName] forState:thumbState];
    [slider addTarget:target action:action forControlEvents:event];
    return slider;
}

@end

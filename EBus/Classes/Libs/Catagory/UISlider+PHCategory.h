//
//  UISlider+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (PHCategory)

/**
 *  创建一个UISlider
 *
 *  @param frame          frame description
 *  @param target         target description
 *  @param action         action description
 *  @param thumbImageName thumbImageName description
 *  @param thumbState     thumbState description
 *  @param event          event description
 *
 *  @return return value description
 */
+ (UISlider *)sliderWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                   thumbImage:(NSString *)thumbImageName
                   thumbState:(UIControlState)thumbState
                 controlEvent:(UIControlEvents)event;
@end









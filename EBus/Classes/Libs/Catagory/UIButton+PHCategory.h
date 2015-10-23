//
//  UIButton+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PHCategory)

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                  normalImage:(UIImage *)imageN
                selectedImage:(UIImage *)imageS;
+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                  normalImage:(UIImage *)imageN
                        title:(NSString *)title;
@end

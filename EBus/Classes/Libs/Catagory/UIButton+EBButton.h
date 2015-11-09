//
//  UIButton+EBButton.h
//  EBus
//
//  Created by Kowloon on 15/11/7.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EBButton)

+ (instancetype)eb_buttonWithTitle:(NSString *)title;
+ (instancetype)eb_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action Title:(NSString *)title;

@end

//
//  UITextField+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PHCategory)
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)style
                    backgroundColor:(UIColor *)backgroundColor
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)textColor
                      textAlignment:(NSTextAlignment)alignment
                               font:(UIFont *)font;
@end

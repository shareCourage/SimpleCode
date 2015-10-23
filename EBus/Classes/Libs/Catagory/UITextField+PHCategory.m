//
//  UITextField+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UITextField+PHCategory.h"

@implementation UITextField (PHCategory)
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)style
                    backgroundColor:(UIColor *)backgroundColor
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)textColor
                      textAlignment:(NSTextAlignment)alignment
                               font:(UIFont *)font
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = style;
    textField.backgroundColor = backgroundColor;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.textAlignment = alignment;
    textField.font = font;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}
@end

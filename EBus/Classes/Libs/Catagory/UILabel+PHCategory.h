//
//  UILabel+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (PHCategory)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font;
- (void)setSystemFontOf12;
- (void)setSystemFontOf11;
- (void)setSystemFontOf10;
- (void)setSystemFontOf13;
- (void)setSystemFontOf14;
- (void)setSystemFontOf15;
- (void)setSystemFontOf16;
- (void)setSystemFontOf17;
- (void)setSystemFontOf18;
- (void)setSystemFontOf19;
- (void)setSystemFontOf20;
- (void)setSystemFontOf21;
- (void)setSystemFontOf22;
- (void)setSystemFontOf23;

- (CGSize)boundingRectWithSize:(CGSize)size;

@end

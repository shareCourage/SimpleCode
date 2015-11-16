//
//  UILabel+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UILabel+PHCategory.h"

@implementation UILabel (PHCategory)
+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
- (void)setSystemFontOf12 {
    self.font = [UIFont systemFontOfSize:12];
}
- (void)setSystemFontOf11 {
    self.font = [UIFont systemFontOfSize:11];
}
- (void)setSystemFontOf10 {
    self.font = [UIFont systemFontOfSize:10];
}

- (void)setSystemFontOf13 {
    self.font = [UIFont systemFontOfSize:13];
}
- (void)setSystemFontOf14 {
    self.font = [UIFont systemFontOfSize:14];
}
- (void)setSystemFontOf15 {
    self.font = [UIFont systemFontOfSize:15];
}
- (void)setSystemFontOf16 {
    self.font = [UIFont systemFontOfSize:16];
}
- (void)setSystemFontOf17 {
    self.font = [UIFont systemFontOfSize:17];
}
- (void)setSystemFontOf18 {
    self.font = [UIFont systemFontOfSize:18];
}
- (void)setSystemFontOf19 {
    self.font = [UIFont systemFontOfSize:19];
}
- (void)setSystemFontOf20 {
    self.font = [UIFont systemFontOfSize:20];
}
- (void)setSystemFontOf21 {
    self.font = [UIFont systemFontOfSize:21];
}
- (void)setSystemFontOf22 {
    self.font = [UIFont systemFontOfSize:22];
}
- (void)setSystemFontOf23 {
    self.font = [UIFont systemFontOfSize:23];
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end

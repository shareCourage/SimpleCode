//
//  PHTabBar.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTabBar.h"
#import "PHTabBarButton.h"

@interface PHTabBar ()
/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) PHTabBarButton *selectedButton;

@end

@implementation PHTabBar
- (void)addTabButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title
{
    // 创建按钮
    PHTabBarButton *button = [PHTabBarButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeCenter;
    // 设置图片
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:EB_RGBColor(128, 138, 165) forState:UIControlStateNormal];
    [button setTitleColor:EB_RGBColor(90, 155, 255) forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 添加
    [self addSubview:button];
    // 监听
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    for (int i = 0; i<count; i++) {
        PHTabBarButton *button = self.subviews[i];
        button.tag = i + 100;
        
        // 设置frame
        CGFloat buttonY = 0;
        CGFloat buttonW = self.frame.size.width / count;
        CGFloat buttonH = self.frame.size.height;
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(PHTabBarButton *)button
{
//    EBLog(@"%ld, %ld",(unsigned long)self.selectedButton.tag, (unsigned long)button.tag);
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:self.selectedButton.tag - 100 to:button.tag - 100];
    }
    
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    
    // 2.让新点击的按钮选中
    button.selected = YES;
    
    // 3.新点击的按钮就成为了"当前选中的按钮"
    self.selectedButton = button;
}

@end

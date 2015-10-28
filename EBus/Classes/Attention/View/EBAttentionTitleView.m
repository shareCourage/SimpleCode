//
//  EBAttentionTitleView.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EBAttentionButtonTag 1000
#import "EBAttentionTitleView.h"
#import "EBAttentionButton.h"

@interface EBAttentionTitleView ()
/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) EBAttentionButton *selectedButton;

@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation EBAttentionTitleView
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName {
    [self addTitleButtonWithName:name selName:selName title:nil];
}

- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title {
    // 创建按钮
    EBAttentionButton *button = [EBAttentionButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeCenter;
    // 设置图片
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    if (title.length != 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:EB_RGBColor(128, 138, 165) forState:UIControlStateNormal];
        [button setTitleColor:EB_RGBColor(90, 155, 255) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    // 添加
    [self addSubview:button];
    [self.buttons addObject:button];
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
    for (int i = 0; i < count; i++) {
        EBAttentionButton *button = self.subviews[i];
        button.tag = i + EBAttentionButtonTag;
        
        // 设置frame
        CGFloat buttonY = 0;
        CGFloat buttonW = self.frame.size.width / count;
        CGFloat buttonH = self.frame.size.height;
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        if (i < count - 1) {
            CGFloat padX = buttonW - 1;
            CGFloat padY = 5;
            CGFloat padW = 1;
            CGFloat padH = 40;
            CGRect padF = CGRectMake(padX, padY, padW, padH);
            UIImageView *padView = [[UIImageView alloc] initWithFrame:padF];
            padView.image = [UIImage imageNamed:@"Attention_pad"];
            [button addSubview:padView];
        }
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(EBAttentionButton *)button
{
    //    EBLog(@"%ld, %ld",(unsigned long)self.selectedButton.tag, (unsigned long)button.tag);
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(titleView:didSelectButtonFrom:to:)]) {
        [self.delegate titleView:self didSelectButtonFrom:self.selectedButton.tag - EBAttentionButtonTag to:button.tag - EBAttentionButtonTag];
    }
    
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    
    // 2.让新点击的按钮选中
    button.selected = YES;
    
    // 3.新点击的按钮就成为了"当前选中的按钮"
    self.selectedButton = button;
}

- (void)selectIndex:(NSUInteger)index {
    if (index <= self.buttons.count - 1) {
        EBAttentionButton *button = self.buttons[index];
        [self buttonClick:button];
    }
}
@end

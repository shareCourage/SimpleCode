//
//  EBPayTypeView.m
//  EBus
//
//  Created by Kowloon on 15/11/2.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EBPayTypeButtonTag 1000

#import "EBPayTypeView.h"
#import "EBPayTypeButton.h"

@interface EBPayTypeView ()

/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) EBPayTypeButton *selectedButton;

@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UIView *backView;

@end

@implementation EBPayTypeView

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        cancel.titleLabel.font = [UIFont systemFontOfSize:22];
        [cancel addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = [UIColor whiteColor];
        cancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancel.layer.borderWidth = 1.f;
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:cancel];
        self.cancelBtn = cancel;
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.backgroundColor = [UIColor whiteColor];
        titleL.layer.borderColor = [UIColor lightGrayColor].CGColor;
        titleL.layer.borderWidth = 1.f;
        titleL.text = @"支付方式";
        titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleL];
        self.titleLabel = titleL;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8f];
        [self insertSubview:backView atIndex:0];
        self.backView = backView;
    }
    return self;
}


- (void)addTitleButtonWithTitle:(NSString *)title imageName:(NSString *)name {
    [self addTitleButtonWithName:name selName:nil title:title];
}

- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName {
    [self addTitleButtonWithName:name selName:selName title:nil];
}

- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title {
    // 创建按钮
    EBPayTypeButton *button = [EBPayTypeButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.f;
    
    // 设置图片
    if (name.length != 0) {
        button.imageView.contentMode = UIViewContentModeCenter;
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    }
    if (selName.length != 0) {
        [button setImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:button];
    [self.buttons addObject:button];
    // 监听
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat leftAndRightSlip = 40;
    CGFloat padding = 10;
    CGFloat widgetW = self.width - leftAndRightSlip * 2;
    CGFloat widgetH = 50;
    
    CGPoint superCenter = self.center;
    CGFloat cancerY = self.height - widgetH / 2 - padding;
    CGPoint cancerCenter = CGPointMake(superCenter.x, cancerY);
    self.cancelBtn.center = cancerCenter;
    self.cancelBtn.bounds = CGRectMake(0, 0, widgetW, widgetH);
    self.cancelBtn.layer.cornerRadius = widgetH / 2;
    
    CGFloat titleCenterY = self.height - self.buttons.count * widgetH - widgetH - widgetH / 2 - padding * 2;
    self.titleLabel.center = CGPointMake(superCenter.x, titleCenterY);
    self.titleLabel.bounds = CGRectMake(0, 0, widgetW, widgetH);
    self.titleLabel.layer.cornerRadius = widgetH / 2;
    self.titleLabel.clipsToBounds = YES;

    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        EBPayTypeButton *pay = self.buttons[i];
        pay.tag = EBPayTypeButtonTag + i;
        pay.bounds = CGRectMake(0, 0, widgetW, widgetH);
        CGFloat payX = superCenter.x;
        CGFloat payY = titleCenterY + (i + 1) * widgetH;
        pay.center = CGPointMake(payX, payY);
        pay.layer.cornerRadius = widgetH / 2;
    }
    self.backView.frame = self.bounds;
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(EBPayTypeButton *)button
{
    if ([self.delegate respondsToSelector:@selector(payTypeView:didSelectIndex:)]) {
        [self.delegate payTypeView:self didSelectIndex:(button.tag - EBPayTypeButtonTag)];
    }
    self.hidden = YES;
}

- (void)tapClick {
    self.hidden = YES;
}


@end

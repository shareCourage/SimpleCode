//
//  EBHotView.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBHotView.h"
#import "EBHotLabel.h"

@interface EBHotView ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *hotL;

@end

@implementation EBHotView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        [label setSystemFontOf22];
        label.text = @"热点地区";
        [self addSubview:label];
        self.hotL = label;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceHorizontal = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat hotH = 35;
    self.hotL.frame = CGRectMake(0, 0, self.width, hotH);
    self.scrollView.frame = CGRectMake(0, hotH, self.width, self.height - hotH);
}

- (void)setHots:(NSArray *)hots {
    _hots = hots;
    if (hots.count == 0) return;
    CGFloat btnH = 50;
    NSUInteger number = hots.count / 3;
    NSUInteger extra = hots.count % 3;
    if (extra != 0) {
        number ++;
    }
    NSUInteger btnTag = 0;
    for (NSUInteger i = 0; i < number; i ++) {
        for (NSUInteger j = 0; j < 3; j ++) {
            EBHotLabel *hot = hots[btnTag];
            CGFloat btnW = self.width / 3 ;
            CGFloat btnX = j * btnW;
            CGFloat btnY = i * btnH;
            CGRect btnF = CGRectMake(btnX, btnY, btnW, btnH);
            UIButton *hotBtn = [self hotButtonTitle:hot.name tag:btnTag frame:btnF];
            [self.scrollView addSubview:hotBtn];
            btnTag ++;
            if (btnTag >= hots.count) break;
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, btnH * number + 20);
}


#pragma mark - Private Method 
- (UIButton *)hotButtonTitle:(NSString *)title tag:(NSUInteger)tag frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = EB_RGBColor(214, 214, 214).CGColor;
    btn.layer.borderWidth = 0.5f;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"search_hLBtn_bg"] forState:UIControlStateNormal];
    btn.frame = frame;
    return btn;
}

- (void)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hotView:didSelectIndex:hotLabel:)]) {
        [self.delegate hotView:self didSelectIndex:sender.tag hotLabel:[self.hots objectAtIndex:sender.tag]];
    }
}
@end





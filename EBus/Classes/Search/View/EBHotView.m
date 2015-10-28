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
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotZoneL;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation EBHotView

+ (instancetype)hotViewFromXib {
    EBHotView *hotView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return hotView;
}

- (void)awakeFromNib {
    EBLog(@"hotView -> awakeFromNib");
    [self.bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    self.hotImageView.image = [UIImage imageNamed:@"search_hot"];
    self.hotImageView.contentMode = UIViewContentModeScaleToFill;
    self.hotZoneL.backgroundColor = [UIColor clearColor];
    self.labelView.backgroundColor = [UIColor clearColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.labelView.width, self.labelView.height)];
    scrollView.alwaysBounceHorizontal = NO;
    [self.labelView addSubview:scrollView];
    self.scrollView = scrollView;
    
    
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
            CGFloat btnW = self.labelView.width / 3 ;
            CGFloat btnX = j * btnW;
            CGFloat btnY = i * btnH;
            CGRect btnF = CGRectMake(btnX, btnY, btnW, btnH);
            UIButton *hotBtn = [self hotButtonTitle:hot.name tag:btnTag frame:btnF];
            [self.scrollView addSubview:hotBtn];
            btnTag ++;
            if (btnTag >= hots.count) break;
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, btnH * number + 200);
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
    btn.frame = frame;
    return btn;
}

- (void)tapClick {
    [UIView animateWithDuration:0.5f animations:^{
        self.hidden = YES;
    }];
}

- (void)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hotView:didSelectIndex:hotLabel:)]) {
        [self.delegate hotView:self didSelectIndex:sender.tag hotLabel:[self.hots objectAtIndex:sender.tag]];
    }
}
@end





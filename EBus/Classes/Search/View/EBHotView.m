//
//  EBHotView.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBHotView.h"

@interface EBHotView ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotZoneL;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *seletedBtn;

@end

@implementation EBHotView


+ (instancetype)hotViewFromXib {
    EBHotView *hotView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
//    hotView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
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
    scrollView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.labelView addSubview:scrollView];
    self.scrollView = scrollView;
    
    
}

- (void)setHots:(NSArray *)hots {
    _hots = hots;
    if (hots.count > 0) {
        CGFloat btnH = 50;
        NSUInteger number = hots.count / 3;
        int btnTag = 1;
        for (NSUInteger i = 0; i < 3; i ++) {
            for (NSUInteger j = 0; j < number; j ++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitle:@"龙华汽车站" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = btnTag;
                [btn setTitleColor:EB_RGBColor(104, 104, 104) forState:UIControlStateNormal];
                CGFloat padding = 1;
                CGFloat btnW = (self.labelView.width - padding) / 3 ;
                CGFloat btnX = i * (btnW + padding);
                CGFloat btnY = j * (btnH + padding) + 1;
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [self.scrollView addSubview:btn];
                btnTag ++;
            }
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, (btnH + 1)* number);
    }
}

- (void)tapClick {
    [UIView animateWithDuration:0.5f animations:^{
        self.hidden = YES;
    }];
}

- (void)btnClick:(UIButton *)sender {
    self.seletedBtn.selected = NO;
    [self.seletedBtn setBackgroundColor:[UIColor whiteColor]];

    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:EB_RGBColor(176, 208, 239)];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    self.seletedBtn = sender;
}
@end





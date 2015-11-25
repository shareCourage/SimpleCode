//
//  EBTransferTipView.m
//  EBus
//
//  Created by Kowloon on 15/11/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferTipView.h"
#import "EBTransferModel.h"

@interface EBTransferTipView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation EBTransferTipView
- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

+ (instancetype)transferTipViewFromXib {
    EBTransferTipView *tipView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    tipView.payL.font = [UIFont systemFontOfSize:60];
    tipView.hmsL.textAlignment = NSTextAlignmentCenter;
    tipView.secLeadingLayout.constant = EB_WidthOfScreen / 2 + 45;
    tipView.secL.textAlignment = NSTextAlignmentLeft;
    tipView.secL.textColor = EB_RGBColor(41, 61, 7);
    tipView.secL.font = [UIFont systemFontOfSize:56.f];
    return tipView;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    } else {
        [self linkStart];
    }
}
- (void)linkStart {
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)tick {
    NSInteger h = [EBTool currentHour];
    NSInteger m = [EBTool currentMinute];
    NSInteger s = [EBTool currentSecond];
    NSString *string = [NSString stringWithFormat:@"%02ld：%02ld：",(unsigned long)h, (unsigned long)m];
    self.secL.text = [NSString stringWithFormat:@"%02ld",(unsigned long)s];
    self.hmsL.text = string;
}

- (void)setTransferModel:(EBTransferModel *)transferModel {
    _transferModel = transferModel;
    NSInteger payType = [transferModel.payType integerValue];
#if DEBUG
//    payType = 2;
#else
#endif
    if (payType == 3) {
        self.backgroundColor = EB_RGBColor(234, 234, 234);
        self.carNumL.textColor = EB_RGBColor(77, 85, 103);
        self.hmsL.textColor = EB_RGBColor(77, 85, 103);
        self.ymdL.textColor = EB_RGBColor(77, 85, 103);
        self.payL.textColor = EB_RGBColor(228, 156, 69);
        self.payL.text = @"未支付";
    } else {
        self.backgroundColor = EB_RGBColor(228, 156, 69);
        for (UILabel *label in self.subviews) {
            label.textColor = [UIColor whiteColor];
        }
        self.secL.textColor = EB_RGBColor(41, 61, 7);
        self.payL.text = @"已支付";
    }
    self.carNumL.text = transferModel.vehCode ? transferModel.vehCode : transferModel.lineName;
    self.ymdL.text = transferModel.runDate;
    [self linkStart];
}

@end

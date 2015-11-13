//
//  EBValidatResultView.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBValidatResultView.h"

@implementation EBValidatResultView

- (IBAction)backBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(validatResultViewDidClickBack:)]) {
        [self.delegate validatResultViewDidClickBack:self];
    }
}

+ (instancetype)EBValidatResultViewFromXib {
    EBValidatResultView *result = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    result.backBtn.layer.cornerRadius = result.backBtn.height / 2;
    [result.backBtn setBackgroundColor:EB_RGBColor(155, 194, 83)];
    return result;
}

- (void)setAuthenticationPass:(BOOL)authenticationPass {
    _authenticationPass = authenticationPass;
    if (authenticationPass) {
        self.failureView.hidden = YES;
        self.successL.hidden = NO;
    } else {
        self.failureView.hidden = NO;
        self.successL.hidden = YES;
    }
}
@end

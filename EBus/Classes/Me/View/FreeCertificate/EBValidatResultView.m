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
    [result.backBtn setBackgroundColor:EB_RGBColor(157, 197, 237)];
    result.failureL.textAlignment = NSTextAlignmentLeft;
    result.failureL.text = @"审核结果： \n很抱歉，由于上传信息模糊或信息不真实等，本次认证不通过！请点击重新认证！";
    result.successL.textAlignment = NSTextAlignmentLeft;
    result.successL.text = @"审核结果： \n恭喜您，认证通过！";
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

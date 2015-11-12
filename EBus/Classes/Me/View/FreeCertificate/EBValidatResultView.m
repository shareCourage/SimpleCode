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
}

+ (instancetype)EBValidatResultViewFromXib {
    EBValidatResultView *result = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    return result;
}

@end

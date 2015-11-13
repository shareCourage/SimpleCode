//
//  EBValidatingView.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBValidatingView.h"

@implementation EBValidatingView

+ (instancetype)EBValidatingViewFromXib {
    EBValidatingView *validating = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    if (EB_WidthOfScreen > 375) {
        [validating.validatingL setSystemFontOf20];
    } else if (EB_WidthOfScreen > 320) {
        [validating.validatingL setSystemFontOf18];
    } else {
        [validating.validatingL setSystemFontOf17];
    }
    return validating;
}

@end

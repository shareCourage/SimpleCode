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
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

@end

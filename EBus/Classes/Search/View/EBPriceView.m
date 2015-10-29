//
//  EBPriceView.m
//  EBus
//
//  Created by Kowloon on 15/10/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBPriceView.h"

@implementation EBPriceView

+ (instancetype)priceViewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}
- (void)awakeFromNib {
    self.priceLabel.text = @"0元";
    self.dayLabel.text = @"共0天";
    
}
@end

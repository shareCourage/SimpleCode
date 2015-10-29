//
//  EBColorView.m
//  EBus
//
//  Created by Kowloon on 15/10/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBColorView.h"

@interface EBColorView ()

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *backColorViews;
@property (weak, nonatomic) IBOutlet UIView *unableView;
@property (weak, nonatomic) IBOutlet UIView *boughtView;

@end

@implementation EBColorView

+ (instancetype)colorViewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

- (void)awakeFromNib {
    for (UIView *view in self.backColorViews) {
        view.backgroundColor = EB_RGBColor(241, 241, 241);
    }
    self.unableView.backgroundColor = EB_RGBColor(241, 241, 241);
    self.boughtView.backgroundColor = EB_RGBColor(230, 146, 35);
    self.backgroundColor = [UIColor whiteColor];
}
@end

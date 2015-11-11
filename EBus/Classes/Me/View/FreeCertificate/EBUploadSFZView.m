//
//  EBUploadSFZView.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBUploadSFZView.h"

@implementation EBUploadSFZView

+ (instancetype)EBUploadSFZViewFromXib {
    EBUploadSFZView *sfzView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    sfzView.sfzTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sfzView.imageBackView.hidden = YES;
    return sfzView;
}

- (IBAction)zjBtnClick:(id)sender {
}
- (IBAction)forwardBtnClick:(id)sender {
}

- (IBAction)commitBtnClick:(id)sender {
}
- (IBAction)deleteBtnClick:(id)sender {
}


@end

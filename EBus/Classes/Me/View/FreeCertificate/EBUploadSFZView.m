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
    sfzView.deleteBtn.tag = EBUploadSFZViewClickTypeOfDelete;
    sfzView.forwardBtn.tag = EBUploadSFZViewClickTypeOfForward;
    sfzView.commitBtn.tag = EBUploadSFZViewClickTypeOfCommit;
    sfzView.zjBtn.tag = EBUploadSFZViewClickTypeOfSFZPhoto;
    
    sfzView.sfzImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    sfzView.zjBtn.layer.cornerRadius = sfzView.zjBtn.height / 2;
    [sfzView.zjBtn setBackgroundColor:EB_RGBColor(155, 194, 83)];
    sfzView.forwardBtn.layer.cornerRadius = sfzView.forwardBtn.height / 2;
    sfzView.commitBtn.layer.cornerRadius = sfzView.commitBtn.height / 2;

    sfzView.nameTF.layer.cornerRadius = sfzView.nameTF.height / 2;
    sfzView.sfzTF.layer.cornerRadius = sfzView.sfzTF.height / 2;
    sfzView.nameTF.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    sfzView.nameTF.layer.borderWidth = 0.7f;
    sfzView.sfzTF.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    sfzView.sfzTF.layer.borderWidth = 0.7f;
    
    sfzView.nameTF.clearButtonMode = UITextFieldViewModeAlways;
    sfzView.sfzTF.clearButtonMode = UITextFieldViewModeAlways;
    
    sfzView.nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, sfzView.nameTF.height)];
    sfzView.sfzTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, sfzView.sfzTF.height)];
    sfzView.nameTF.leftViewMode = UITextFieldViewModeAlways;
    sfzView.sfzTF.leftViewMode = UITextFieldViewModeAlways;

//    sfzView.nameTF.text = @"aaa";
//    sfzView.sfzTF.text = @"362502199009062244";
    return sfzView;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == EBUploadSFZViewClickTypeOfDelete) {
        self.sfzImageView.image = nil;
        self.imageBackView.hidden = YES;
        self.zjBtn.hidden = NO;
    }
    if ([self.delegate respondsToSelector:@selector(uploadSFZViewDidClick:type:)]) {
        [self.delegate uploadSFZViewDidClick:self type:sender.tag];
    }
}

#pragma mark - Public
- (void)setSFZImage:(UIImage *)image {
    self.imageBackView.hidden = NO;
    self.sfzImageView.image = image;
    self.zjBtn.hidden = YES;
}

@end

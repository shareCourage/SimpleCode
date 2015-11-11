//
//  EBUploadZJView.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBUploadZJView.h"


@implementation EBUploadZJView
+ (instancetype)EBUploadZJViewFromXib {
    EBUploadZJView *zjView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    zjView.imageBackView.hidden = YES;
    return zjView;
}


- (IBAction)nextBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadZJViewDidClickNextBtn:)]) {
        [self.delegate uploadZJViewDidClickNextBtn:self];
    }
}

- (IBAction)zjTypeBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadZJViewDidClickZJTypeBtn:)]) {
        [self.delegate uploadZJViewDidClickZJTypeBtn:self];
    }
}
- (IBAction)zjPhotoBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadZJViewDidClickZJPhotoBtn:)]) {
        [self.delegate uploadZJViewDidClickZJPhotoBtn:self];
    }
    
}
- (IBAction)deleteZJBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadZJViewDidClickDeletePhotoBtn:)]) {
        [self.delegate uploadZJViewDidClickDeletePhotoBtn:self];
    }
    
}
#pragma mark - Public
- (void)setZJImage:(UIImage *)image {
    self.imageBackView.hidden = NO;
    self.zjImageView.image = image;
    self.zjPhotoBtn.hidden = YES;
}
@end

//
//  EBUploadZJView.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBUploadZJView.h"
#import "EBZJTypeButton.h"

@implementation EBUploadZJView
+ (instancetype)EBUploadZJViewFromXib {
    EBUploadZJView *zjView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    zjView.imageBackView.hidden = YES;
    
    zjView.zjTypeBtn.tag = EBUploadZJViewClickTypeOfZJType;
    zjView.zjTypeBtn.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7f].CGColor;
    zjView.zjTypeBtn.layer.borderWidth = 1.f;
    zjView.zjTypeBtn.layer.cornerRadius = zjView.zjTypeBtn.height / 2;
    zjView.zjTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    zjView.zjPhotoBtn.tag = EBUploadZJViewClickTypeOfZJPhoto;
    zjView.zjPhotoBtn.layer.cornerRadius = zjView.zjPhotoBtn.height / 2;
    [zjView.zjPhotoBtn setBackgroundColor:EB_RGBColor(155, 194, 83)];
    
    zjView.nextBtn.tag = EBUploadZJViewClickTypeOfNext;
    zjView.nextBtn.layer.cornerRadius = zjView.nextBtn.height / 2;
    
    zjView.zjImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    zjView.deleteZJBtn.tag = EBUploadZJViewClickTypeOfDeletePhoto;
    return zjView;
}


- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == EBUploadZJViewClickTypeOfDeletePhoto) {
        self.zjImageView.image = nil;
        self.imageBackView.hidden = YES;
        self.zjPhotoBtn.hidden = NO;
    } else if (sender.tag == EBUploadZJViewClickTypeOfZJType) {
        sender.selected = !sender.selected;
    }
    if ([self.delegate respondsToSelector:@selector(uploadZJViewDidClick:type:)]) {
        [self.delegate uploadZJViewDidClick:self type:sender.tag];
    }
}


#pragma mark - Public
- (void)setZJImage:(UIImage *)image {
    self.imageBackView.hidden = NO;
    self.zjImageView.image = image;
    self.zjPhotoBtn.hidden = YES;
}
- (void)setZJTypeTitle:(NSString *)title {
    [self.zjTypeBtn setTitle:title forState:UIControlStateNormal];
}
@end

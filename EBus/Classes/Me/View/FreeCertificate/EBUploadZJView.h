//
//  EBUploadZJView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBUploadZJView;

@protocol EBUploadZJViewDelegate <NSObject>

@optional
- (void)uploadZJViewDidClickZJTypeBtn:(EBUploadZJView *)zjView;
- (void)uploadZJViewDidClickZJPhotoBtn:(EBUploadZJView *)zjView;
- (void)uploadZJViewDidClickNextBtn:(EBUploadZJView *)zjView;
- (void)uploadZJViewDidClickDeletePhotoBtn:(EBUploadZJView *)zjView;

@end


@interface EBUploadZJView : UIView

@property (nonatomic, weak) id <EBUploadZJViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *zjTypeL;
@property (weak, nonatomic) IBOutlet UIButton *zjTypeBtn;
- (IBAction)zjTypeBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zjPhotoBtn;
- (IBAction)zjPhotoBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *zjImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteZJBtn;
- (IBAction)deleteZJBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(id)sender;

+ (instancetype)EBUploadZJViewFromXib;

- (void)setZJImage:(UIImage *)image;

@end

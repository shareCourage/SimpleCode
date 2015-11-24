//
//  EBUploadZJView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBUploadZJView, EBZJTypeButton;

typedef  NS_ENUM(NSUInteger, EBUploadZJViewClickType) {
    EBUploadZJViewClickTypeOfZJType = 100000,
    EBUploadZJViewClickTypeOfZJPhoto,
    EBUploadZJViewClickTypeOfNext,
    EBUploadZJViewClickTypeOfDeletePhoto,
    EBUploadZJViewClicTypeOfkNone
};

@protocol EBUploadZJViewDelegate <NSObject>

@optional
- (void)uploadZJViewDidClick:(EBUploadZJView *)zjView type:(EBUploadZJViewClickType)type;

@end


@interface EBUploadZJView : UIView

@property (nonatomic, weak) id <EBUploadZJViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *zjTypeL;
@property (weak, nonatomic) IBOutlet EBZJTypeButton *zjTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zjPhotoBtn;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *zjImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteZJBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

+ (instancetype)EBUploadZJViewFromXib;
- (void)setZJImage:(UIImage *)image;
- (void)setZJTypeTitle:(NSString *)title;
@end

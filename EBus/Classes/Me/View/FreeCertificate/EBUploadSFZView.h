//
//  EBUploadSFZView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBUploadSFZView;
typedef  NS_ENUM(NSUInteger, EBUploadSFZViewClickType) {
    EBUploadSFZViewClickTypeOfSFZPhoto = 100000,
    EBUploadSFZViewClickTypeOfForward,
    EBUploadSFZViewClickTypeOfCommit,
    EBUploadSFZViewClickTypeOfDelete,
    EBUploadSFZViewClickTypeOfNone
};

@protocol EBUploadSFZViewDelegate <NSObject>

@optional
- (void)uploadSFZViewDidClick:(EBUploadSFZView *)sfzView type:(EBUploadSFZViewClickType)type;

@end

@interface EBUploadSFZView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sfzTF;
@property (weak, nonatomic) IBOutlet UIButton *zjBtn;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *sfzImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) id <EBUploadSFZViewDelegate> delegate;
+ (instancetype)EBUploadSFZViewFromXib;
- (void)setSFZImage:(UIImage *)image;
@end

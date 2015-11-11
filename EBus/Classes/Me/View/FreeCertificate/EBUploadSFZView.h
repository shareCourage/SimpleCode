//
//  EBUploadSFZView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBUploadSFZView : UIView

+ (instancetype)EBUploadSFZViewFromXib;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sfzTF;
@property (weak, nonatomic) IBOutlet UIButton *zjBtn;
- (IBAction)zjBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *sfzImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)forwardBtnClick:(id)sender;
- (IBAction)commitBtnClick:(id)sender;
@end

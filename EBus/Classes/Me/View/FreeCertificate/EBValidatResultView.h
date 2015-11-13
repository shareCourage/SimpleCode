//
//  EBValidatResultView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBValidatResultView;

@protocol EBValidatResultViewDelegate <NSObject>

@optional
- (void)validatResultViewDidClickBack:(EBValidatResultView *)resultView;

@end

@interface EBValidatResultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *successL;
@property (weak, nonatomic) IBOutlet UIView *failureView;
@property (weak, nonatomic) IBOutlet UILabel *failureL;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtnClick:(UIButton *)sender;

@property (weak, nonatomic) id <EBValidatResultViewDelegate>delegate;
+ (instancetype)EBValidatResultViewFromXib;

@property (nonatomic, assign) BOOL authenticationPass;
@end

//
//  EBTransferTipView.h
//  EBus
//
//  Created by Kowloon on 15/11/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBTransferModel;

@interface EBTransferTipView : UIView

@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *payL;
@property (weak, nonatomic) IBOutlet UILabel *hmsL;
@property (weak, nonatomic) IBOutlet UILabel *ymdL;
@property (weak, nonatomic) IBOutlet UILabel *secL;

+ (instancetype)transferTipViewFromXib;
@property (nonatomic, strong) EBTransferModel *transferModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secLeadingLayout;
@end

//
//  EBOrderStatusView.h
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBOrderDetailModel, EBOrderSpecificModel;

@interface EBOrderStatusView : UIView

//@property (nonatomic, strong) EBOrderDetailModel *orderModel;
@property (nonatomic, strong) EBOrderSpecificModel *specificModel;
+ (instancetype)orderStatusViewFromXib;
@end

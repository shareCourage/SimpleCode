//
//  EBPriceView.h
//  EBus
//
//  Created by Kowloon on 15/10/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPriceView : UIView
+ (instancetype)priceViewFromXib;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

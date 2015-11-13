//
//  EBValidatingView.h
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBValidatingView : UIView

+ (instancetype)EBValidatingViewFromXib;
@property (weak, nonatomic) IBOutlet UILabel *validatingL;

@end

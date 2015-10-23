//
//  EBHotView.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBHotView : UIView

+ (instancetype)hotViewFromXib;

@property (nonatomic, strong) NSArray *hots;

@end

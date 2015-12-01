//
//  EBHotView.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBHotView, EBHotLabel;

@protocol EBHotViewDelegate <NSObject>

@optional
- (void)hotView:(EBHotView *)hotView didSelectIndex:(NSUInteger)index hotLabel:(EBHotLabel *)hotLabel;

@end

@interface EBHotView : UIView

@property (nonatomic, weak) id <EBHotViewDelegate> delegate;

@property (nonatomic, strong) NSArray *hots;

@end

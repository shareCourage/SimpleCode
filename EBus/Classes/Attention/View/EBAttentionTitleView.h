//
//  EBAttentionTitleView.h
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBAttentionTitleView;

@protocol EBAttentionTitleViewDelegate <NSObject>

@optional
- (void)titleView:(EBAttentionTitleView *)titleView didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to;

@end

@interface EBAttentionTitleView : UIView

@property (nonatomic, weak) id <EBAttentionTitleViewDelegate> delegate;

- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName;
- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title;

- (void)selectIndex:(NSUInteger)index;

@end

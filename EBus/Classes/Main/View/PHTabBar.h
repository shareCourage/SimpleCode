//
//  PHTabBar.h
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHTabBar, PHTabBarButton;

@protocol PHTabBarDelegate <NSObject>

@optional
- (void)tabBar:(PHTabBar *)tabBar didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to;

@end

@interface PHTabBar : UIView

@property (nonatomic, weak)id<PHTabBarDelegate>delegate;

/**
 *  用来添加一个内部的按钮
 *
 *  @param name    按钮图片
 *  @param selName 按钮选中时的图片
 */
- (PHTabBarButton *)addTabButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title;
- (void)setSelectIndex:(NSUInteger)index;
@end

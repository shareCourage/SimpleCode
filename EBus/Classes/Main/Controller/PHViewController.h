//
//  PHViewController.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHViewController : UIViewController

/*
 *监听控制器进入后台执行
 */
- (void)viewControllerDidEnterBackground;

/*
 *监听控制器进入前台执行
 */
- (void)viewControllerDidBecomeActive;


- (void)viewControllerWillResignActive;

@property (nonatomic, assign, getter = isAppearRefresh) BOOL appearRefresh;

@end

//
//  UIViewController+PHCategory.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/15.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PHCategory)
/**
 *  获取当前处于activity状态的view controller
 *
 */
+ (UIViewController *)activityViewController;
@end

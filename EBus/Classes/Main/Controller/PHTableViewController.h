//
//  PHTableViewController.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHTableViewController : UITableViewController

- (void)viewControllerDidEnterBackground;

- (void)viewControllerDidBecomeActive;


//默认为YES
@property (nonatomic, assign) BOOL backgroundImageViewDisappear;
@property (nonatomic, assign, getter = isAppearRefresh) BOOL appearRefresh;

@end

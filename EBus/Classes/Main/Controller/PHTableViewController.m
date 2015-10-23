//
//  PHTableViewController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTableViewController.h"

@interface PHTableViewController ()

@end

@implementation PHTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//    UIImage *image = [UIImage imageNamed:@"search_delete"];
//    self.view.layer.contents = (__bridge id _Nullable)(image.CGImage);
}

- (void)viewControllerDidEnterBackground{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewControllerDidBecomeActive{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

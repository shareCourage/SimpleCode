//
//  PHViewController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"

@interface PHViewController ()

@end

@implementation PHViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    EBLog(@"%@ --> dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewControllerDidEnterBackground{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewControllerDidBecomeActive{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
- (void)viewControllerWillResignActive{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
@end



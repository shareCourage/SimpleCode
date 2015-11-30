//
//  PHViewController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
#import "MobClick.h"

@interface PHViewController ()

@end

@implementation PHViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    EBLog(@"%@ --> dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appearRefresh = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.appearRefresh = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])]];
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



//
//  PHTableViewController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/29.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTableViewController.h"

@interface PHTableViewController ()
@property (nonatomic, weak) UIImageView *backgroundImageView;

@end

@implementation PHTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    EBLog(@"%@ --> dealloc", NSStringFromClass([self class]));
}

- (void)setBackgroundImageViewDisappear:(BOOL)backgroundImageViewDisappear {
    _backgroundImageViewDisappear = backgroundImageViewDisappear;
    self.backgroundImageView.hidden = backgroundImageViewDisappear;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.hidden = YES;
    backgroundImageView.contentMode = UIViewContentModeCenter;
    UIImage *image = [UIImage imageNamed:@"main_background"];
    backgroundImageView.image = image;
    self.tableView.backgroundView = backgroundImageView;
    self.backgroundImageView = backgroundImageView;
}

- (void)viewControllerDidEnterBackground{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewControllerDidBecomeActive{
    EBLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

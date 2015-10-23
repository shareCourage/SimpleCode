//
//  EBLoginViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLoginViewController.h"

@interface EBLoginViewController ()

@end

@implementation EBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"登录";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftItemClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

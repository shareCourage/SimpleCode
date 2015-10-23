//
//  PHTabBarController.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTabBarController.h"
#import "PHTabBar.h"

@interface PHTabBarController ()<PHTabBarDelegate>

@end

@implementation PHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PHTabBar *myTabBar = [[PHTabBar alloc] init];
    myTabBar.backgroundColor = [UIColor clearColor];
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    NSArray *tabBar = @[@"tabbar_contacts",@"tabbar_discover",@"tabbar_mainframe",@"tabbar_me"];
    NSArray *tabBarSel = @[@"tabbar_contactsHL",@"tabbar_discoverHL",@"tabbar_mainframeHL",@"tabbar_meHL"];
    NSArray *tabBarName = @[@"查询",@"乘车",@"关注",@"我的"];
    // 2.添加对应个数的按钮
    for (int i = 0; i < self.viewControllers.count; i++) {
        NSString *name = tabBar[i];
        NSString *selName = tabBarSel[i];
        NSString *title = tabBarName[i];
        [myTabBar addTabButtonWithName:name selName:selName title:title];
    }
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    EBLog(@"item ->  %@",item);
}

/**
 normal : 普通状态
 highlighted : 高亮(用户长按的时候达到这个状态)
 disable : enabled = NO
 selected :  selected = YES
 */
#pragma mark - PHTabBar的代理方法
- (void)tabBar:(PHTabBar *)tabBar didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to
{
    self.selectedIndex = to;
    NSLog(@"%lu",(unsigned long)to);
}

@end





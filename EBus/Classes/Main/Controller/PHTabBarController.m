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
    myTabBar.backgroundColor = EB_RGBColor(39, 39, 39);
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    NSArray *tabBar = @[@"tabBar_search_normal",@"tabBar_byBus_normal",@"tabBar_attention_normal",@"tabBar_me_normal"];
    NSArray *tabBarSel = @[@"tabBar_search_select",@"tabBar_byBus_select",@"tabBar_attention_select",@"tabBar_me_select"];
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





//
//  EBMoreViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMoreViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"

@interface EBMoreViewController ()

@end

@implementation EBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self one];
}


- (void)one {
    PHSettingItem *problem = [PHSettingArrowItem itemWithTitle:@"常见问题" destVcClass:nil];
    PHSettingItem *guide = [PHSettingArrowItem itemWithTitle:@"用户指南" destVcClass:nil];
    PHSettingItem *protocol = [PHSettingArrowItem itemWithTitle:@"使用协议" destVcClass:nil];
    PHSettingItem *aboutUs = [PHSettingArrowItem itemWithTitle:@"关于我们" destVcClass:nil];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[problem,guide,protocol,aboutUs];
    [self.dataSource addObject:group];
}

@end



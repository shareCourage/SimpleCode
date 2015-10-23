//
//  EBMeSettingController.m
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMeSettingController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"

@interface EBMeSettingController ()

@end

@implementation EBMeSettingController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self one];
    
}

- (void)one
{
    PHSettingItem *ticket = [PHSettingArrowItem itemWithTitle:@"我的订单" destVcClass:nil];
    PHSettingItem *notification = [PHSettingArrowItem itemWithTitle:@"我的通知" destVcClass:nil];
    PHSettingItem *szt = [PHSettingArrowItem itemWithTitle:@"深圳通卡" destVcClass:nil];
    PHSettingItem *freeCertificate = [PHSettingArrowItem itemWithTitle:@"免费证件" destVcClass:nil];
    PHSettingItem *advice = [PHSettingArrowItem itemWithTitle:@"投诉建议" destVcClass:nil];
    PHSettingItem *versionUpdate = [PHSettingArrowItem itemWithTitle:@"版本更新" destVcClass:nil];
    PHSettingItem *more = [PHSettingArrowItem itemWithTitle:@"更多" destVcClass:nil];

    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[ticket,notification,szt,freeCertificate,advice,versionUpdate,more];
    [self.dataSource addObject:group];
}

@end









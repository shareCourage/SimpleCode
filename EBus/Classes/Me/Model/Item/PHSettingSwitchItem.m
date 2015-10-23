//
//  PHSettingSwitchItem.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHSettingSwitchItem.h"

@implementation PHSettingSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    PHSettingSwitchItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}


+ (instancetype)itemWithTitle:(NSString *)title completion:(PHSettingSwitchStatus)status {
    PHSettingSwitchItem *item = [self itemWithTitle:title destVcClass:nil];
    item.status = status;
    return item;
}

@end








//
//  PHSettingSwitchItem.h
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHSettingItem.h"

typedef void (^PHSettingSwitchStatus)(BOOL enable);

@interface PHSettingSwitchItem : PHSettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@property (nonatomic, copy)PHSettingSwitchStatus status;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

+ (instancetype)itemWithTitle:(NSString *)title completion:(PHSettingSwitchStatus)status;
@end

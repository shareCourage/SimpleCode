//
//  PHSettingItem.h
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PHSettingItemOption)();

@interface PHSettingItem : NSObject

/**
 *  图标
 */
@property (nonatomic, strong) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  子标题
 */
@property (nonatomic, strong) NSString *subtitle;


/**
 *  点击那个cell需要做什么事情
 */
@property (nonatomic, copy) PHSettingItemOption option;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
@end














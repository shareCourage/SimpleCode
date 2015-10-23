//
//  PHSettingGroup.h
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHSettingGroup : NSObject
/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *header;
/**
 *  尾部标题
 */
@property (nonatomic, copy) NSString *footer;
/**
 *  存放着这组所有行的模型数据(这个数组中都是PHSettingItem对象)
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property(nonatomic, assign, getter = isOpened)BOOL opened;

+ (instancetype)settingGoup;
@end

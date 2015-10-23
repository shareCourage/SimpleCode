//
//  NSDictionary+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/4.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PHCategory)

/*
 *根据从这个字典获取的值，如果为空，则返回defaultValue 否则返回获取到的值，并且转化为double类型
 */
- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;


@end

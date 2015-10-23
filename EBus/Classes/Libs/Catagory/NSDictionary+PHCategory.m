//
//  NSDictionary+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/4.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "NSDictionary+PHCategory.h"

@implementation NSDictionary (PHCategory)
- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue{
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] doubleValue];
}
@end

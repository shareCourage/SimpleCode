//
//  NSArray+MySeperateString.m
//  MyIOSWithHair
//
//  Created by WITHIOS on 15-1-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NSArray+MySeperateString.h"

@implementation NSArray (MySeperateString)
#pragma mark - 用来分割字符串的方法
+ (NSArray *)seprateString:(NSString *)string characterSet:(NSString *)set
{
    NSString *stringTransforToUTF = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:set];
    NSArray *arr = [stringTransforToUTF componentsSeparatedByCharactersInSet:cSet];
    return arr;
}
@end

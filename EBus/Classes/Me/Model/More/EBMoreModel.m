//
//  EBMoreModel.m
//  EBus
//
//  Created by Kowloon on 15/11/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMoreModel.h"
#import <MJExtension/MJExtension.h>
@implementation EBMoreModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBMoreModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBMoreModel objectWithKeyValues:dict];
    }
    return self;
}

@end

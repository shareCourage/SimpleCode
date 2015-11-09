//
//  EBMyOrderModel.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderModel.h"

@implementation EBMyOrderModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBMyOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBMyOrderModel objectWithKeyValues:dict];
    }
    return self;
}

@end

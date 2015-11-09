//
//  EBMyOrderUncompletedModel.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderUncompletedModel.h"

@implementation EBMyOrderUncompletedModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBMyOrderUncompletedModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBMyOrderUncompletedModel objectWithKeyValues:dict];
    }
    return self;
}

@end

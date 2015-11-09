//
//  EBMyOrderCompletedModel.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderCompletedModel.h"

@implementation EBMyOrderCompletedModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBMyOrderCompletedModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBMyOrderCompletedModel objectWithKeyValues:dict];
    }
    return self;
}

@end

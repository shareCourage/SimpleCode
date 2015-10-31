//
//  EBSearchResultModel.m
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchResultModel.h"

@implementation EBSearchResultModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBSearchResultModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBSearchResultModel objectWithKeyValues:dict];
    }
    return self;
}

@end

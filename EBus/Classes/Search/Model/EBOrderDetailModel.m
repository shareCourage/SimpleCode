//
//  EBOrderDetailModel.m
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderDetailModel.h"

@implementation EBOrderDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBOrderDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBOrderDetailModel objectWithKeyValues:dict];
    }
    return self;
}

@end

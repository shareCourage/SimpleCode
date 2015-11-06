//
//  EBTransferModel.m
//  EBus
//
//  Created by Kowloon on 15/11/6.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferModel.h"

@implementation EBTransferModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBTransferModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBTransferModel objectWithKeyValues:dict];
    }
    return self;
}

@end

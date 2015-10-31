//
//  EBGroupModel.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBGroupModel.h"

@implementation EBGroupModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        [EBGroupModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBGroupModel objectWithKeyValues:dict];
    }
    return self;
}

@end

//
//  EBSignModel.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSignModel.h"

@implementation EBSignModel


- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        [EBSignModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBSignModel objectWithKeyValues:dict];
    }
    return self;
}

@end

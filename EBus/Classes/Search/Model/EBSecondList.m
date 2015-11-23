//
//  EBSecondList.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSecondList.h"

@implementation EBSecondList



- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBSecondList setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBSecondList objectWithKeyValues:dict];
    }
    return self;
}
@end

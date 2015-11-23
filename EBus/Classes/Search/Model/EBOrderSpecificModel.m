//
//  EBOrderSpecificModel.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderSpecificModel.h"
#import "EBSecondList.h"

@implementation EBOrderSpecificModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBOrderSpecificModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBOrderSpecificModel objectWithKeyValues:dict];
        NSArray *secondList = dict[@"secondList"];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *obj in secondList) {
            EBSecondList *secL = [[EBSecondList alloc] initWithDict:obj];
            [mArray addObject:secL];
        }
        self.secondList = [mArray copy];
    }
    return self;
}

@end







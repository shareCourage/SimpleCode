//
//  EBSearchResultModel.m
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchResultModel.h"
#import <MJExtension/MJExtension.h>

@implementation EBSearchResultModel

MJCodingImplementation

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self = [EBSearchResultModel objectWithKeyValues:dict];
    }
    return self;
}

@end

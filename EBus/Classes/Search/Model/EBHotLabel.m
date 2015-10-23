//
//  EBHotLabel.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBHotLabel.h"
#import <MJExtension/MJExtension.h>

@implementation EBHotLabel

MJCodingImplementation

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self = [EBHotLabel objectWithKeyValues:dict];
    }
    return self;
}

@end

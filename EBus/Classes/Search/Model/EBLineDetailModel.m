//
//  EBLineDetailModel.m
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineDetailModel.h"
#import <MJExtension/MJExtension.h>

@implementation EBLineDetailModel

MJCodingImplementation

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self = [EBLineDetailModel objectWithKeyValues:dict];
    }
    return self;
}

@end

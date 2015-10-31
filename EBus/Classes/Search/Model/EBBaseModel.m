//
//  EBBaseModel.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@implementation EBBaseModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self = [EBBaseModel objectWithKeyValues:dict];
    }
    return self;
}

@end

//
//  EBSponsorModel.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSponsorModel.h"

@implementation EBSponsorModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        [EBSponsorModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBSponsorModel objectWithKeyValues:dict];
    }
    return self;
}

@end

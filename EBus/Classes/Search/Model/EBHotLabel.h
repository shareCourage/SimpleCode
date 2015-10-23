//
//  EBHotLabel.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBHotLabel : NSObject <NSCoding>
/*
 "id": 1,
 "isDele": "0",
 "name": "固戍",
 "sortNum": 1,
 "version": 0
 */

@property (nonatomic, copy) NSString *isDele;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *sortNum;
@property (nonatomic, strong) NSNumber *version;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

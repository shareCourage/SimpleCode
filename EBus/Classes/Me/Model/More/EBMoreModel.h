//
//  EBMoreModel.h
//  EBus
//
//  Created by Kowloon on 15/11/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBMoreModel : NSObject
/*
 "id": 1,
 "isDele": "0",
 "sortNum": 1,
 "title": "常见问题",
 "version": 0
 */
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *sortNum;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, copy) NSString *isDele;
@property (nonatomic, copy) NSString *title;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

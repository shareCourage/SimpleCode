//
//  EBLineDetailModel.h
//  EBus
//
//  Created by Kowloon on 15/10/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBLineDetailModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *lineContent;
@property (nonatomic, copy) NSString *offFjIds;
@property (nonatomic, copy) NSString *offLngLat;
@property (nonatomic, copy) NSString *offStations;
@property (nonatomic, copy) NSString *onFjIds;
@property (nonatomic, copy) NSString *onLngLat;
@property (nonatomic, copy) NSString *onStations;
@property (nonatomic, strong) NSNumber *openType;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

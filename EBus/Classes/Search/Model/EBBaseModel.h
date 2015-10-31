//
//  EBBaseModel.h
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface EBBaseModel : NSObject

@property (nonatomic, copy) NSString *offStationName;
@property (nonatomic, copy) NSString *onStationName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *vehTime;
@property (nonatomic, strong) NSNumber *mileage;
@property (nonatomic, strong) NSNumber *needTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

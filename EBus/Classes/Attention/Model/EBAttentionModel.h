//
//  EBAttentionModel.h
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBAttentionModel : NSObject

@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *offLat;
@property (nonatomic, copy) NSString *offLng;
@property (nonatomic, copy) NSString *offStationName;
@property (nonatomic, copy) NSString *onLat;
@property (nonatomic, copy) NSString *onLng;
@property (nonatomic, copy) NSString *onStationName;
@property (nonatomic, copy) NSString *vehTime;
@property (nonatomic, strong) NSNumber *customerId;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *mileage;
@property (nonatomic, strong) NSNumber *needTime;
@property (nonatomic, strong) NSNumber *offGeogId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onGeogId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *perNum;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *changeStatus;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

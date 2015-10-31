//
//  EBBoughtModel.h
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBBoughtModel : EBBaseModel
/*
 "codeKey": "17_36_0800_0800_20521_6591",
 "customerId": 17,
 "id": 1,
 "lineId": 36,
 "mileage": 17.53,
 "needTime": 60,
 "offStationId": 6591,
 "offStationName": "冶金大厦",
 "onStationId": 20521,
 "onStationName": "文博宫",
 "price": 2,
 "startTime": "0800",
 "status": 5,
 "tradePrice": 0.4,
 "vehTime": "0800"
 */
//@property (nonatomic, copy) NSString *offStationName;
//@property (nonatomic, copy) NSString *onStationName;
//@property (nonatomic, copy) NSString *startTime;
//@property (nonatomic, strong) NSNumber *mileage;
//@property (nonatomic, strong) NSNumber *needTime;

@property (nonatomic, copy) NSString *codeKey;
@property (nonatomic, strong) NSNumber *customerId;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *tradePrice;


@end

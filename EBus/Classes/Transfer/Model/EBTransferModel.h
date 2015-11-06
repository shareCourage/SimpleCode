//
//  EBTransferModel.h
//  EBus
//
//  Created by Kowloon on 15/11/6.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBTransferModel : EBBaseModel
/*
 "alipayCost": 0,
 "id": 1,
 "isTicket": 0,
 "lineId": 1,
 "mainId": 1,
 "mileage": 20, AA
 "needTime": 10, AA
 "offStationId": 3,
 "offStationName": "2",  AA
 "onStationId": 3,
 "onStationName": "2", AA
 "originalPrice": 3,
 "perName": "2",
 "runDate": "2015-08-30",
 "startTime": "0700", AA
 "status": 2,
 "tradePrice": 2,
 "userId": 222,
 "userName": "18244973821",
 "vehCode": "B54524",
 "vehTime": "0720"   AA
 */

@property (nonatomic, strong) NSNumber *alipayCost;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *isTicket;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *mainId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *tradePrice;
@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, copy) NSString *perName;
@property (nonatomic, copy) NSString *runDate;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *vehCode;

@end

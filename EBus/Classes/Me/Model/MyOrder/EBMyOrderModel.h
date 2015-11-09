//
//  EBMyOrderModel.h
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBMyOrderModel : EBBaseModel

@property (nonatomic, strong) NSNumber *alipayCost;
@property (nonatomic, strong) NSNumber *dayNum;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *opType;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSNumber *refundNum;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *tradePrice;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *userName;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *mainNo;
@property (nonatomic, copy) NSString *saleDates;
@property (nonatomic, copy) NSString *orderTime;


@end

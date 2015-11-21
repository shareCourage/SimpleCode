//
//  EBOrderDetailModel.h
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBOrderDetailModel : EBBaseModel
/*
 onStationName = "\U897f\U4e61\U594b\U8fbe\U79d1\U6280";
 offStationName = "\U5357\U5c71\U6c7d\U8f66\U7ad9";
 mileage = "17.74";
 needTime = 60;
 startTime = 1535;
 vehTime = 1535;
 alipayCost = 0;
 dayNum = 3;
 id = 130;
 lineId = 1;
 mainNo = 2015110300000008;
 offStationId = 20827;
 onStationId = 256;
 opType = 2;
 payType = 1;
 refundNum = 0;
 status = 0;
 timeKey = 20151103;
 userId = 956;
 userName = 15818572527;
 lineName = "\U673a\U573a-\U5357\U5934";
 orderTime = "2015-11-03 11:04";
 originalPrice = "1.5";
 tradePrice = "1.5";
 saleDates = "2015-11-03,2015-11-04,2015-11-05";

 
 */
@property (nonatomic, strong) NSNumber *alipayCost;
@property (nonatomic, strong) NSNumber *dayNum;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *mainNo;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *opType;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSNumber *refundNum;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *userName;

@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *saleDates;
@property (nonatomic, copy) NSString *tradePrice;
@property (nonatomic, copy) NSString *originalPrice;


@end


#import "EBSearchResultModel.h"
@class EBOrderDetailModel;

@interface EBSearchResultModel (OrderDetailModel)

+ (instancetype)resultModelFromOrderDetailModel:(EBOrderDetailModel *)orderModel;

@end



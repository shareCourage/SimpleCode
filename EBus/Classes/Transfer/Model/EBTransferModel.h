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
 alipayCost = 0;
 arriveTime = 0800;
 id = 419;
 isArrage = 0;
 isFree = 1;
 isTicket = 0;
 lineId = 22;
 lineName = "\U5929\U6c47\U5927\U53a6\U7ebf";
 mainId = 326;
 offStationId = 7269;
 onStationId = 4314;
 originalPrice = 2;
 payNo = 555522228;
 payType = 3;
 runDate = "2015-11-27";
 status = 2;
 tradePrice = 2;
 userId = 956;
 userName = 15818572527;
 
 vehTime = 0730;            ~~~~~~~~~~~~~~~~~~~
 startTime = 0730;      ~~~~~~~~~~~~~~~~~~~
 onStationName = "\U9ec4\U9601\U5751\U5e02\U573a";  ~~~~~~~~~~~~~~~~~~~
 offStationName = "\U79d1\U6280\U56ed\U2460";   ~~~~~~~~~~~~~~~~~~~
 mileage = "42.26"; ~~~~~~~~~~~~~~~~~~~
 needTime = 30;     ~~~~~~~~~~~~~~~~~~~
 */

@property (nonatomic, strong) NSNumber *alipayCost;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *isArrage;
@property (nonatomic, strong) NSNumber *isFree;
@property (nonatomic, strong) NSNumber *isTicket;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *mainId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *payNo;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *tradePrice;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *runDate;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *arriveTime;
@property (nonatomic, copy) NSString *vehCode;
@end

#import "EBSearchResultModel.h"

@interface EBSearchResultModel (TransferModel)

+ (instancetype)resultModelFromTransferModel:(EBTransferModel *)transferModel;

@end



//
//  EBSecondList.h
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBSecondList : EBBaseModel

/*
 alipayCost = 0;
 arriveTime = 1855;
 carTeam = "317\U8f66\U961f";
 carTeamId = 14;
 companyId = 1;
 companyName = "\U4e00\U516c\U53f8";
 id = 607;
 isArrage = 1;
 isFree = 0;
 isTicket = 0;
 lineId = 140;
 lineName = "\U5929\U6c47\U5927\U53a6-\U56fd\U82b1\U8def\U53e3";
 mainId = 488;
 mileage = "44.72";
 needTime = 75;
 offStationId = 12357;
 offStationName = "\U56fd\U82b1\U8def\U53e3\Uff08\U4e34\U65f6\U7ad9\Uff09";
 onStationId = 12356;
 onStationName = "\U5929\U6c47\U5927\U53a6\Uff08\U4e34\U65f6\U7ad9\Uff09";
 originalPrice = "0.5";
 payType = 1;
 perName = "\U9f9a\U5e08\U5085";
 runDate = "2015-11-26";
 startTime = 1740;
 status = 1;
 tradePrice = "0.5";
 userId = 1014;
 userName = 13316996080;
 vehCode = "\U7ca4BBV648";
 vehTime = 1740;
 */
@property (nonatomic, strong) NSNumber *alipayCost;
@property (nonatomic, strong) NSNumber *arriveTime;
@property (nonatomic, strong) NSNumber *carTeamId;
@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *isArrage;
@property (nonatomic, strong) NSNumber *isFree;
@property (nonatomic, strong) NSNumber *isTicket;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *mainId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *userName;
@property (nonatomic, copy) NSString *carTeam;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *originalPrice;
@property (nonatomic, copy) NSString *perName;
@property (nonatomic, copy) NSString *runDate;
@property (nonatomic, copy) NSString *tradePrice;
@property (nonatomic, copy) NSString *vehCode;

@end

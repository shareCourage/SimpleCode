//
//  EBOrderSpecificModel.h
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderDetailModel.h"

@interface EBOrderSpecificModel : EBOrderDetailModel

@property (nonatomic, strong) NSNumber *carTeamId;
@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, copy) NSString *carTeam;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, strong) NSArray *secondList;

//@property (nonatomic, strong) NSNumber *alipayCost;
//@property (nonatomic, strong) NSNumber *dayNum;
//@property (nonatomic, strong) NSNumber *ID;
//@property (nonatomic, strong) NSNumber *lineId;
//@property (nonatomic, strong) NSNumber *mainNo;
//@property (nonatomic, strong) NSNumber *offStationId;
//@property (nonatomic, strong) NSNumber *onStationId;
//@property (nonatomic, strong) NSNumber *opType;
//@property (nonatomic, strong) NSNumber *payType;
//@property (nonatomic, strong) NSNumber *refundNum;
//@property (nonatomic, strong) NSNumber *status;
//@property (nonatomic, strong) NSNumber *timeKey;
//@property (nonatomic, strong) NSNumber *userId;
//@property (nonatomic, strong) NSNumber *userName;
//@property (nonatomic, copy) NSString *lineName;
//@property (nonatomic, copy) NSString *orderTime;
//@property (nonatomic, copy) NSString *originalPrice;
//@property (nonatomic, copy) NSString *saleDates;
//@property (nonatomic, copy) NSString *tradePrice;

/*
 alipayCost = 0;
 carTeam = "317\U8f66\U961f";
 carTeamId = 14;
 companyId = 1;
 companyName = "\U4e00\U516c\U53f8";
 dayNum = 1;
 id = 488;
 lineId = 140;
 lineName = "\U5929\U6c47\U5927\U53a6-\U56fd\U82b1\U8def\U53e3";
 mainNo = 2015112000000027;
 mileage = "44.72";
 needTime = 75;
 offStationId = 12357;
 offStationName = "\U56fd\U82b1\U8def\U53e3\Uff08\U4e34\U65f6\U7ad9\Uff09";
 onStationId = 12356;
 onStationName = "\U5929\U6c47\U5927\U53a6\Uff08\U4e34\U65f6\U7ad9\Uff09";
 opType = 2;
 orderTime = "2015-11-20 17:17";
 originalPrice = "0.5";
 payType = 1;
 refundNum = 0;
 remarks = "\U8d85\U65f6\U53d6\U6d88\U8ba2\U5355";
 saleDates = "2015-11-26";
 secondList =         (
 {
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
 }
 );
 status = 1;
 timeKey = 20151120;
 tradePrice = "0.5";
 userId = 1014;
 userName = 13316996080;
 startTime = 1740;
 vehTime = 1740;
 */
@end





//
//  EBSignModel.h
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAttentionModel.h"

@interface EBSignModel : EBAttentionModel
/*
 addTime = "2015-10-28 18:47";
 changeStatus = 1;
 customerId = 956;
 customerName = 15818572527;
 id = 1376;
 lineId = 31;
 mileage = "37.99";
 needTime = 30;
 offGeogId = 3;
 offLat = "22.558198";
 offLng = "114.027699";
 offStationId = 6159;
 offStationName = "\U5317\U73af\U9999\U6885\U7acb\U4ea4";
 onGeogId = 7;
 onLat = "22.632152";
 onLng = "114.012";
 onStationId = 12179;
 onStationName = "\U7b80\U4e0a\U6751";
 perNum = 11;
 price = 2;
 startTime = 0700;
 status = 0;
 timeKey = 20151028;
 type = 2;
 vehTime = 0700;
 */


@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *price;

@end

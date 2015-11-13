//
//  EBSearchResultModel.h
//  EBus
//
//  Created by Kowloon on 15/10/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBSearchResultModel : EBBaseModel <NSCoding>
/*
 "id": 2,
 "isEnd": 1,
 "isFirst": 1,
 "isLabel": 1,
 "lineId": 1,
 "mileage": 12.86,
 "needTime": 55,
 "offGeogId": 5,
 "offStationId": 7544,
 "offStationName": "西丽劳力市场",
 "onGeogId": 11,
 "onStationId": 21504,
 "onStationName": "简上路口北",
 "openType": 1,
 "perNum": 0,
 "price": 2,
 "startTime": "0700",
 "status": 5,
 "tradePrice": 2,
 "vehTime": "0700"
 */
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *isEnd;
@property (nonatomic, strong) NSNumber *isFirst;
@property (nonatomic, strong) NSNumber *isLabel;
@property (nonatomic, strong) NSNumber *lineId;
@property (nonatomic, strong) NSNumber *offGeogId;
@property (nonatomic, strong) NSNumber *offStationId;
@property (nonatomic, strong) NSNumber *onGeogId;
@property (nonatomic, strong) NSNumber *onStationId;
@property (nonatomic, strong) NSNumber *openType;
@property (nonatomic, strong) NSNumber *perNum;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *tradePrice;

//@property (nonatomic, strong) NSNumber *mileage;
//@property (nonatomic, strong) NSNumber *needTime;
//@property (nonatomic, copy) NSString *offStationName;
//@property (nonatomic, copy) NSString *onStationName;
//@property (nonatomic, copy) NSString *startTime;
//@property (nonatomic, copy) NSString *vehTime;


@end

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
 "addTime": "2015-08-18 18:19",
 "customerId": 7,
 "customerName": "18244973821",
 "id": 11,
 "lineId": 45,
 "mileage": 0,
 "needTime": 0,
 "offGeogId": 5,
 "offLat": "22.541121",
 "offLng": "113.256421",
 "offStationId": 12025,
 "offStationName": "南山区教育局",
 "onGeogId": 4,
 "onLat": "22.6545",
 "onLng": "114.542124",
 "onStationId": 12024,
 "onStationName": "罗胡区教育局",
 "perNum": 0,
 "status": 0,
 "timeKey": 20150818,
 "type": 2,
 "vehTime": "0740",
 "price": 2,
 "changeStatus": 4
 */


@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *price;

@end

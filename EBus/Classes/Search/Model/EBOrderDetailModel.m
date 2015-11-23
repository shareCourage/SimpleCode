//
//  EBOrderDetailModel.m
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderDetailModel.h"

@implementation EBOrderDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBOrderDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBOrderDetailModel objectWithKeyValues:dict];
    }
    return self;
}

@end


//#import "EBOrderDetailModel.h"

@implementation EBSearchResultModel (OrderDetailModel)

+ (instancetype)resultModelFromOrderDetailModel:(EBOrderDetailModel *)orderModel {
    EBSearchResultModel *resultModel = [[EBSearchResultModel alloc] init];
    resultModel.lineId = orderModel.lineId;
    resultModel.offStationId = orderModel.offStationId;
    resultModel.onStationId = orderModel.onStationId;
    resultModel.startTime = orderModel.startTime;
    resultModel.vehTime = orderModel.vehTime;
    resultModel.onStationName = orderModel.onStationName;
    resultModel.offStationName = orderModel.offStationName;
    resultModel.mileage = orderModel.mileage;
    resultModel.needTime = orderModel.needTime;
    resultModel.ID = orderModel.ID;
    resultModel.price = @([orderModel.tradePrice floatValue]);
    resultModel.openType = @(1);
    return resultModel;
}

@end

//
//  EBTransferModel.m
//  EBus
//
//  Created by Kowloon on 15/11/6.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferModel.h"

@implementation EBTransferModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [EBTransferModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [EBTransferModel objectWithKeyValues:dict];
    }
    return self;
}

@end


@implementation EBSearchResultModel (TransferModel)

+ (instancetype)resultModelFromTransferModel:(EBTransferModel *)transferModel {
    EBSearchResultModel *resultModel = [[EBSearchResultModel alloc] init];
    resultModel.lineId = transferModel.lineId;
    resultModel.offStationId = transferModel.offStationId;
    resultModel.onStationId = transferModel.onStationId;
    resultModel.startTime = transferModel.startTime;
    resultModel.vehTime = transferModel.vehTime;
    resultModel.onStationName = transferModel.onStationName;
    resultModel.offStationName = transferModel.offStationName;
    resultModel.mileage = transferModel.mileage;
    resultModel.needTime = transferModel.needTime;
    resultModel.ID = transferModel.ID;
    resultModel.price = transferModel.tradePrice;
    return resultModel;

}

@end
//
//  EBPayTool.h
//  EBus
//
//  Created by Kowloon on 15/11/4.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class EBOrderDetailModel;

typedef void (^EBOptionDict)(NSDictionary *dict);

typedef  NS_ENUM(NSUInteger, EBPayType) {
    EBPayTypeOfAlipay = 1,
    EBPayTypeOfWeChat,
    EBPayTypeOfSZT,
    EBPayTypeOfOther,
};

@interface EBPayTool : NSObject

singleton_interface(EBPayTool)
+ (BOOL)canPayByWeXin;

- (void)payType:(EBPayType)type orderModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion;
- (void)wxPayWithModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion;
- (void)aliPayWithModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion;

@end

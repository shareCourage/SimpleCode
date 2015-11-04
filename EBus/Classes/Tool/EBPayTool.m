//
//  EBPayTool.m
//  EBus
//
//  Created by Kowloon on 15/11/4.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBPayTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
#import "EBOrderDetailModel.h"

@interface EBPayTool () <UIAlertViewDelegate>

@property (nonatomic, copy) EBOptionDict completion;

@end

@implementation EBPayTool


+ (instancetype)payTool {
    return [[self alloc] init];
}

- (BOOL)payType:(EBPayType)type orderModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion {
    if (completion) self.completion = completion;
    switch (type) {
        case EBPayTypeOfAlipay:
            [self aliPay:orderModel];
            break;
        case EBPayTypeOfWeChat:
            [self weChatPay:orderModel];
            break;
        case EBPayTypeOfSZT:
            [self sztPay:orderModel];
            break;
        case EBPayTypeOfOther:
            [self otherPay:orderModel];
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)aliPay:(EBOrderDetailModel *)orderModel {
    if (!orderModel.mainNo) return;
    NSString *service = static_Alipay_Scheme;
    NSString *partner = static_Alipay_Partner;
    NSString *inputCharset = @"utf-8";
    NSString *tradeNo = [NSString stringWithFormat:@"%@",orderModel.mainNo];
    NSString *productName = @"车票";//商品的标题/交易标题/订单标题/订单关键字等。该参数最长为128个汉字。
    NSString *paymentType = @"1";
    NSString *seller = static_Alipay_Seller;
    NSString *amount = [NSString stringWithFormat:@"%@",orderModel.tradePrice];//total_fee
    NSArray *saleDates = [orderModel.saleDates componentsSeparatedByString:@","];
    NSString *productDec = [NSString stringWithFormat:@"%ld天车票",(unsigned long)saleDates.count];//body 对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
    NSString *itBPay = @"30m";
    NSString *privateKey = static_Alipay_PrivateKey;//sign
    NSString *appScheme = static_App_Schemes;
    NSString *notifyUrl = static_Alipay_notifyUrl;//支付宝服务器主动通知商户网站里指定的页面http路径

    [self alipayWithPartner:partner
                     seller:seller
                    tradeNO:tradeNo
                productName:productName
         productDescription:productDec
                     amount:amount
                  notifyURL:notifyUrl
                    service:service
                paymentType:paymentType
               inputCharset:inputCharset
                     itBPay:itBPay
                 privateKey:privateKey
                  appScheme:appScheme];
}

- (void)weChatPay:(EBOrderDetailModel *)orderModel {
    
}

- (void)sztPay:(EBOrderDetailModel *)orderModel {

}

- (void)otherPay:(EBOrderDetailModel *)orderModel {

}

#pragma mark - AliPay
- (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                  service:(NSString *)service
              paymentType:(NSString *)paymentType
             inputCharset:(NSString *)inputCharset
                   itBPay:(NSString *)itBPay
               privateKey:(NSString *)privateKey
                appScheme:(NSString *)appScheme {
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO;
    order.productName = productName;
    order.productDescription = productDescription;
    order.amount = amount;
    order.notifyURL = notifyURL;
    order.service = service;
    order.paymentType = paymentType;
    order.inputCharset = inputCharset;
    order.itBPay = itBPay;
    
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    NSString *signedString = [self genSignedStringWithPrivateKey:privateKey OrderSpec:orderSpec];
    
    // 调用支付接口
    [self payWithAppScheme:appScheme orderSpec:orderSpec signedString:signedString];
}

// 生成signedString
- (NSString *)genSignedStringWithPrivateKey:(NSString *)privateKey OrderSpec:(NSString *)orderSpec {
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    return [signer signString:orderSpec];
}

// 支付
- (void)payWithAppScheme:(NSString *)appScheme orderSpec:(NSString *)orderSpec signedString:(NSString *)signedString {
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"payWithAppScheme->reslut = %@",resultDic);
            if (self.completion) self.completion(resultDic);
        }];
    }
    
}
@end

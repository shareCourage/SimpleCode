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
#import "WXApi.h"
#import "ApiXml.h"
#import "WechatPayUtil.h"
#import "payRequsestHandler.h"
#import "WXUtil.h"

@interface EBPayTool () <UIAlertViewDelegate>

@property (nonatomic, copy) EBOptionDict completion;

@end

@implementation EBPayTool
singleton_implementation(EBPayTool)

- (void)dealloc {
    EBLog(@"%@ --> dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (BOOL)canPayByWeXin {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)wxPayWithModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion {
    [self payType:EBPayTypeOfWeChat orderModel:orderModel completion:completion];
}

- (void)aliPayWithModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion {
    [self payType:EBPayTypeOfAlipay orderModel:orderModel completion:completion];
}

- (void)payType:(EBPayType)type orderModel:(EBOrderDetailModel *)orderModel completion:(EBOptionDict)completion {
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
    EBLog(@"%@",NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpaySuccess) name:EBWXPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayfailure) name:EBWXPayFailureNotification object:nil];
    NSString *appid = static_WeChat_AppID;
    NSString *mch_id = static_WeChat_MchId;
    NSString *nonce_str = [self getNonceStr];
    
    NSArray *saleDates = [orderModel.saleDates componentsSeparatedByString:@","];
    NSString *body = [NSString stringWithFormat:@"%ld天车票",(unsigned long)saleDates.count];//商品或支付单简要描述
    
    NSString *out_trade_no = [NSString stringWithFormat:@"%@",orderModel.mainNo];//订单号
    NSString *spbill_create_ip = [WechatPayUtil getIPAddress:YES];//APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
    NSString *notify_url = static_WeChat_notifyUrl;
    NSString *trade_type = @"APP";
    NSString *limit_pay = @"no_credit";//否
    CGFloat total_fee = [orderModel.tradePrice floatValue];

    NSDictionary *parameters = @{@"appid"             : appid,
                                 @"mch_id"            : mch_id,
                                 @"nonce_str"         : nonce_str,
                                 @"body"              : body,
                                 @"out_trade_no"      : out_trade_no,
                                 @"spbill_create_ip"  : spbill_create_ip,
                                 @"notify_url"        : notify_url,
                                 @"trade_type"        : trade_type,
                                 @"limit_pay"         : limit_pay,
                                 @"total_fee"         : [NSString stringWithFormat:@"%.f",total_fee * 100]};
    NSMutableDictionary *mPara = [NSMutableDictionary dictionaryWithDictionary:parameters];
  
    payRequsestHandler *handle = [[payRequsestHandler alloc] init];
    //设置密钥
    [handle setKey:static_WeChat_Key];
#pragma mark - 第一次签名 构造xml数据
    NSString *xmlStr = [handle genPackage:mPara];
#pragma mark - 网络请求后获取的数据，获取prepay_id(预付单号)
    NSData *res = [WXUtil httpSend:static_WeChat_PayUrl method:@"POST" data:xmlStr];
    XMLHelper *xml  = [[XMLHelper alloc] init];
    //开始解析
    [xml startParse:res];
#pragma mark - 将xml数据转化为字典格式
    NSMutableDictionary *resParams = [xml getDict];
    /*
resParams     {
     appid = wx009a523c3077f55e;
     "mch_id" = 1269105601;
     "nonce_str" = O8reT8C765jbBJs3;
     "prepay_id" = wx20151106091321d515e19c0d0412821841;
     "result_code" = SUCCESS;
     "return_code" = SUCCESS;
     "return_msg" = OK;
     sign = A34011418422BAEA9A20115909771B46;
     "trade_type" = APP;
     }
     */
    NSString *prepayId = resParams[@"prepay_id"];
    if (prepayId.length != 0) {
#pragma mark - 构造第二次签名需要的字典
        NSMutableDictionary *secondSignPara = [NSMutableDictionary dictionary];
        NSString *package = @"Sign=WXPay";
        NSString *timeStamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
        [secondSignPara setObject:appid                 forKey:@"appid"];
        [secondSignPara setObject:[self getNonceStr]    forKey:@"noncestr"];
        [secondSignPara setObject:package               forKey:@"package"];
        [secondSignPara setObject:mch_id                forKey:@"partnerid"];
        [secondSignPara setObject:prepayId              forKey:@"prepayid"];
        [secondSignPara setObject:timeStamp             forKey:@"timestamp"];
#pragma mark -获取签名后的sign
        NSString *secondSignStr = [handle createMd5Sign:secondSignPara];//生成签名数据
        if (secondSignStr.length != 0) {
            [secondSignPara setObject:secondSignStr forKey:@"sign"];
        }
#pragma mark - 构造PayReq对象
        NSString *stamp = [secondSignPara objectForKey:@"timestamp"];
        PayReq *req = [[PayReq alloc] init];
        req.openID              = [secondSignPara objectForKey:@"appid"];
        req.partnerId           = [secondSignPara objectForKey:@"partnerid"];
        req.prepayId            = [secondSignPara objectForKey:@"prepayid"];
        req.nonceStr            = [secondSignPara objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [secondSignPara objectForKey:@"package"];
        req.sign                = [secondSignPara objectForKey:@"sign"];
#pragma mark - 发起支付
        [WXApi sendReq:req];//发送支付请求,打开微信客户端，点击支付，然后会重新打开本app，内部会发送通知，有这个类来接收
    } else {
        EBLog(@"获取prepay_id失败");
    }
}
- (void)sztPay:(EBOrderDetailModel *)orderModel {
}

- (void)otherPay:(EBOrderDetailModel *)orderModel {
    
}
#pragma mark - wexinPayNotification
- (void)wxpaySuccess {
    EBLog(@"%@",NSStringFromSelector(_cmd));
#warning 这里还需要从服务器请求确认支付成功数据
    NSDictionary *dict = @{@"payResult":@"success"};
    if (self.completion) self.completion(dict);
}
- (void)wxpayfailure {
    EBLog(@"%@",NSStringFromSelector(_cmd));
    NSDictionary *dict = @{@"payResult":@"failure"};
    if (self.completion) self.completion(dict);
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


#pragma mark - WeXinPay Method
/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)getNonceStr
{
    return [WechatPayUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    EBLog(@"#1.生成字符串 -> %@",signString);
    NSString *key = [NSString stringWithFormat:@"&key=%@",static_WeChat_Key];
    signString = [signString stringByAppendingString:key];
    EBLog(@"#2.连接商户key： -> %@",signString);
    NSString *result = [WechatPayUtil md5:signString];
    EBLog(@"#3.md5编码 ->  %@", result);
    NSString *upper = [result uppercaseString];
    EBLog(@"大写 ——》 %@",upper);
    return upper;
}

@end

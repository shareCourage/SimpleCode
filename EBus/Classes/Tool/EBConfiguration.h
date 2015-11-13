//
//  EBConfiguration.h
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#ifndef EBConfiguration_h
#define EBConfiguration_h
static NSString * const EBPresentLoginVCDidFinishNotification = @"eb.present.login.present.finish";
static NSString * const EBLoginSuccessNotification = @"eb.login.success";
static NSString * const EBLogoutSuccessNotification = @"eb.logout.success";
static NSString * const EBWXPaySuccessNotification = @"eb.wxpay.success";
static NSString * const EBWXPayFailureNotification = @"eb.wxpay.failure";
static NSString * const EBDidSaveUsualLineNotification = @"eb.saveUsualLine.notification";

static NSString *static_KeyOfAMap           = @"163c0486f490bf1c8c84ed7c1a8a9507";

static NSString *static_Alipay_Appid        = @"2015082700236900";
static NSString *static_Alipay_Partner      = @"2088021510586444";
static NSString *static_Alipay_Seller       = @"2088021510586444";
static NSString *static_Alipay_Telephone    = @"13316996080";
static NSString *static_Alipay_Email        = @"270007107@qq.com";
static NSString *static_Alipay_PrivateKey   = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALLyS3oGvXD9m3i3FajXWvFncJBCeqZ/KsuBtiiL13SlooS5rcndETNEdG9ggrWC9AD4QOJRIHvIixOiHoVuh4/OfEAnz0guhkGvIzDyFRK0vRrrnNSskyrITqJvdhQbbyHZUJreZkhx0lsTbgsav6uQbDIMUIVkqLehi7gLoUvNAgMBAAECgYADgumkPVmeS/uvBLiyFXe9YPA+hG9vsPMgBy2R4hyaN13XCOW2HlZmESPPw68M7MLo+fYb+seOZkMEYZwDtkWGrnBvcSG88ncNZXz+VzXvHVx91oDoi6bmcm3CYK4oof690cWSxx7M5Zd4V5E31PquJuY8tbMtpKicojDWki4nKQJBAOtyQyEAUPtCGFtuMbkQvSVybgFR5orIZ4cviZhXB3RfvZw9gB/eOrTgUMElxHYrPoUGL35YTrKZYNFYPoeVOIMCQQDCkWClbc4m7Jl+Os3QQMkops3DIITpw/mIvpaQJY5p30EZwvhd3nH9Xr54MU3FH/Ia2SYAQZndAfGHDLQ8oxlvAkEAzcdk8m/zV1ayMR8DaEs/9X2otZCeXUfAbD/ZE4Nk6YpQD0EVPUUerD2tdtKKfflXwC3izpth1OkG3JEyvY9m/wJAQWf7lEEAbydURhHghCRzOv4v52t0It1lcimXlad6Y27QhKd9NJkFusXxw5fXa+/cRFhBJQ7oeVog5mRH5qZxcwJBAIY2FfDw8Xst/sodxiDsrF9X2dP8dg1UUHy8DxYlP6SRBVe750XPz//izRUOCOACN9I2obHd3OBtYGdG4rG8OIg=";
static NSString *static_Alipay_notifyUrl    = @"http://app.szebus.net/alipay/phone/notify/url";
static NSString *static_Alipay_Scheme       = @"mobile.securitypay.pay";

static NSString *static_WeChat_Scheme       = @"weixin";
static NSString *static_WeChat_AppID        = @"wx009a523c3077f55e";
static NSString *static_WeChat_PayUrl       = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
static NSString *static_WeChat_MchId        = @"1269105601";
static NSString *static_WeChat_Key          = @"sdfASD65468ASs48sv4a66wqwe99POMM";
static NSString *static_WeChat_notifyUrl    = @"http://app.szebus.net/weixin/phone/notify/url";
static NSString *static_App_Schemes         = @"eBus";

static NSString *static_Url_Host            = @"http://app.szebus.net";
#define static_Url_Open                 [static_Url_Host stringByAppendingPathComponent:@"phone/open"]
#define static_Url_SearchBus_Label      [static_Url_Host stringByAppendingPathComponent:@"label/phone/bc/data"]
#define static_Url_HotLabel             [static_Url_Host stringByAppendingPathComponent:@"label/phone/data"]
#define static_Url_SearchBus            [static_Url_Host stringByAppendingPathComponent:@"bc/phone/data"]
#define static_Url_LineDetail           [static_Url_Host stringByAppendingPathComponent:@"line/phone/detail"]
#define static_Url_LinePhoto            [static_Url_Host stringByAppendingPathComponent:@"line/phone/station/fj"]
#define static_Url_SurplusTicket        [static_Url_Host stringByAppendingPathComponent:@"bc/phone/surplus/ticket"]
#define static_Url_GetCode              [static_Url_Host stringByAppendingPathComponent:@"code/phone/login"]
#define static_Url_Login                [static_Url_Host stringByAppendingPathComponent:@"phone/login"]
#define static_Url_Suggest              [static_Url_Host stringByAppendingPathComponent:@"evaluate/phone/upload/data"]
#define static_Url_Order                [static_Url_Host stringByAppendingPathComponent:@"order/phone/create"]
#define static_Url_Sign                 [static_Url_Host stringByAppendingPathComponent:@"demand/phone/apply/save"]
#define static_Url_Sponsor              [static_Url_Host stringByAppendingPathComponent:@"demand/phone/line/create"]
#define static_Url_AttentionOfBought    [static_Url_Host stringByAppendingPathComponent:@"customer/phone/buy/data"]
#define static_Url_AttentionOfSign      [static_Url_Host stringByAppendingPathComponent:@"demand/phone/system/apply/data"]
#define static_Url_AttentionOfGroup     [static_Url_Host stringByAppendingPathComponent:@"demand/phone/customer/apply/data"]
#define static_Url_AttentionOfSponsor   [static_Url_Host stringByAppendingPathComponent:@"demand/phone/customer/create/data"]
#define static_Url_CancelOrder          [static_Url_Host stringByAppendingPathComponent:@"order/phone/cancel"]
#define static_Url_TransferOfRecentLine [static_Url_Host stringByAppendingPathComponent:@"order/phone/second/now/data"]
#define static_Url_SetSZTNo             [static_Url_Host stringByAppendingPathComponent:@"szt/phone/set/info"]
#define static_Url_SZTNotice            [static_Url_Host stringByAppendingPathComponent:@"szt/phone/notice"]
#define static_Url_ChangePayType        [static_Url_Host stringByAppendingPathComponent:@"order/phone/change/pay/type"]
#define static_Url_MyOrder              [static_Url_Host stringByAppendingPathComponent:@"order/phone/main/data"]
#define static_Url_Refund               [static_Url_Host stringByAppendingPathComponent:@"order/phone/refund"]
#define static_Url_CustomerDetail       [static_Url_Host stringByAppendingPathComponent:@"customer/phone/detail"]//用户信息
#define static_Url_CustomerCertificate  [static_Url_Host stringByAppendingPathComponent:@"customer/phone/certificate/detail"]//用户免费证件认证状态信息
#define static_Url_UserShouldKnow       [static_Url_Host stringByAppendingPathComponent:@"customer/phone/notice"]//用户须知


#define static_Url_UploadCertificate    @"http://pz.szebus.net/phone/upload/customer/certificate"//用户免费证件上传

#define static_Url_MoreList             [static_Url_Host stringByAppendingPathComponent:@"more/phone/data"]//更多
#define static_Url_MoreDetail           [static_Url_Host stringByAppendingPathComponent:@"more/phone/record/detail"]//更多


static NSString *static_Argument_returnData     = @"returnData";
static NSString *static_Argument_returnCode     = @"returnCode";
static NSString *static_Argument_returnInfo     = @"returnInfo";
static NSString *static_Argument_phone          = @"phone";
static NSString *static_Argument_labelId        = @"labelId";
static NSString *static_Argument_onLngLat       = @"onLngLat";
static NSString *static_Argument_offLngLat      = @"offLngLat";
static NSString *static_Argument_lineId         = @"lineId";
static NSString *static_Argument_bcStationId    = @"bcStationId";
static NSString *static_Argument_customerName   = @"customerName";
static NSString *static_Argument_customerId     = @"customerId";
static NSString *static_Argument_userName       = @"userName";
static NSString *static_Argument_userId         = @"userId";
static NSString *static_Argument_beginDate      = @"beginDate";
static NSString *static_Argument_endDate        = @"endDate";
static NSString *static_Argument_vehTime        = @"vehTime";
static NSString *static_Argument_loginName      = @"loginName";
static NSString *static_Argument_loginCode      = @"loginCode";
static NSString *static_Argument_type           = @"type";
static NSString *static_Argument_content        = @"content";
static NSString *static_Argument_onGeogName     = @"onGeogName";
static NSString *static_Argument_onStationName  = @"onStationName";
static NSString *static_Argument_onLng          = @"onLng";
static NSString *static_Argument_onLat          = @"onLat";
static NSString *static_Argument_offGeogName    = @"offGeogName";
static NSString *static_Argument_offStationName = @"offStationName";
static NSString *static_Argument_offLng         = @"offLng";
static NSString *static_Argument_offLat         = @"offLat";
static NSString *static_Argument_onStationId    = @"onStationId";
static NSString *static_Argument_offStationId   = @"offStationId";
static NSString *static_Argument_startTime      = @"startTime";
static NSString *static_Argument_saleDates      = @"saleDates";
static NSString *static_Argument_tradePrice     = @"tradePrice";
static NSString *static_Argument_payType        = @"payType";
static NSString *static_Argument_sztNo          = @"sztNo";
static NSString *static_Argument_id             = @"id";
static NSString *static_Argument_resultStatus   = @"resultStatus";
static NSString *static_Argument_payResult      = @"payResult";
static NSString *static_Argument_payStatus      = @"payStatus";
static NSString *static_Argument_runDate        = @"runDate";
static NSString *static_Argument_status         = @"status";
static NSString *static_Argument_perName        = @"perName";
static NSString *static_Argument_identityNo     = @"identityNo";
static NSString *static_Argument_certType       = @"certType";

static NSString *static_Argument_certificateStatus  = @"certificateStatus";
static NSString *static_Argument_certificateType    = @"certificateType";
#endif /* EBConfiguration_h */






//static NSString *static_Url_Open            = @"http://app.szebus.net/phone/open";
//static NSString *static_Url_SearchBus_Label = @"http://app.szebus.net/label/phone/bc/data";
//static NSString *static_Url_HotLabel        = @"http://app.szebus.net/label/phone/data";
//static NSString *static_Url_SearchBus       = @"http://app.szebus.net/bc/phone/data";
//static NSString *static_Url_LineDetail      = @"http://app.szebus.net/line/phone/detail";
//static NSString *static_Url_LinePhoto       = @"http://app.szebus.net/line/phone/station/fj";
//static NSString *static_Url_SurplusTicket   = @"http://app.szebus.net/bc/phone/surplus/ticket";
//static NSString *static_Url_GetCode         = @"http://app.szebus.net/code/phone/login";
//static NSString *static_Url_Login           = @"http://app.szebus.net/phone/login";
//static NSString *static_Url_Suggest         = @"http://app.szebus.net/evaluate/phone/upload/data";
//static NSString *static_Url_Order           = @"http://app.szebus.net/order/phone/create";
//static NSString *static_Url_Sign            = @"http://app.szebus.net/demand/phone/apply/save";
//static NSString *static_Url_Sponsor         = @"http://app.szebus.net/demand/phone/line/create";
//static NSString *static_Url_AttentionOfBought   = @"http://app.szebus.net/customer/phone/buy/data";
//static NSString *static_Url_AttentionOfSign     = @"http://app.szebus.net/demand/phone/system/apply/data";
//static NSString *static_Url_AttentionOfGroup    = @"http://app.szebus.net/demand/phone/customer/apply/data";
//static NSString *static_Url_AttentionOfSponsor  = @"http://app.szebus.net/demand/phone/customer/create/data";
//static NSString *static_Url_CancelOrder         = @"http://app.szebus.net/order/phone/cancel";
//static NSString *static_Url_TransferOfRecentLine    = @"http://app.szebus.net/order/phone/second/now/data";
//static NSString *static_Url_SetSZTNo                = @"http://app.szebus.net/szt/phone/set/info";
//static NSString *static_Url_ChangePayType           = @"http://app.szebus.net/order/phone/change/pay/type";
//static NSString *static_Url_MyOrder                 = @"http://app.szebus.net/order/phone/main/data";
//static NSString *static_Url_Refund                  = @"http://app.szebus.net/order/phone/refund";//退票退款操作

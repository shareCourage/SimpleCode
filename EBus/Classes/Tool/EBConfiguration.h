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

static NSString *static_KeyOfAMap           = @"163c0486f490bf1c8c84ed7c1a8a9507";

static NSString *static_Url_Open            = @"http://app.szebus.net/phone/open";
static NSString *static_Url_SearchBus_Label = @"http://app.szebus.net/label/phone/bc/data";
static NSString *static_Url_HotLabel        = @"http://app.szebus.net/label/phone/data";
static NSString *static_Url_Host            = @"http://app.szebus.net";
static NSString *static_Url_SearchBus       = @"http://app.szebus.net/bc/phone/data";
static NSString *static_Url_LineDetail      = @"http://app.szebus.net/line/phone/detail";
static NSString *static_Url_LinePhoto       = @"http://app.szebus.net/line/phone/station/fj";
static NSString *static_Url_SurplusTicket   = @"http://app.szebus.net/bc/phone/surplus/ticket";
static NSString *static_Url_GetCode         = @"http://app.szebus.net/code/phone/login";
static NSString *static_Url_Login           = @"http://app.szebus.net/phone/login";
static NSString *static_Url_Suggest         = @"http://app.szebus.net/evaluate/phone/upload/data";
static NSString *static_Url_Order           = @"http://app.szebus.net/order/phone/create";
static NSString *static_Url_Sign            = @"http://app.szebus.net/demand/phone/apply/save";
static NSString *static_Url_Sponsor         = @"http://app.szebus.net/demand/phone/line/create";

static NSString *static_Url_AttentionOfBought   = @"http://app.szebus.net/customer/phone/buy/data";
static NSString *static_Url_AttentionOfSign     = @"http://app.szebus.net/demand/phone/system/apply/data";
static NSString *static_Url_AttentionOfGroup    = @"http://app.szebus.net/demand/phone/customer/apply/data";
static NSString *static_Url_AttentionOfSponsor  = @"http://app.szebus.net/demand/phone/customer/create/data";

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


#endif /* EBConfiguration_h */

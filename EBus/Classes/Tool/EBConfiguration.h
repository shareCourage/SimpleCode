//
//  EBConfiguration.h
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#ifndef EBConfiguration_h
#define EBConfiguration_h

static NSString *static_KeyOfAMap           = @"163c0486f490bf1c8c84ed7c1a8a9507";

static NSString *static_Url_Host            = @"http://app.szebus.net";
static NSString *static_Url_SearchBus       = @"http://app.szebus.net/bc/phone/data";
static NSString *static_Url_LineDetail      = @"http://app.szebus.net/line/phone/detail";
static NSString *static_Url_LinePhoto       = @"http://app.szebus.net/line/phone/station/fj";
static NSString *static_Url_HotLabel        = @"http://app.szebus.net/label/phone/data";
static NSString *static_Url_SurplusTicket   = @"http://app.szebus.net/bc/phone/surplus/ticket";
static NSString *static_Url_GetCode         = @"http://app.szebus.net/code/phone/login";
static NSString *static_Url_Login           = @"http://app.szebus.net/phone/login";
static NSString *static_Url_Suggest         = @"http://app.szebus.net/evaluate/phone/upload/data";

static NSString *static_Argument_phone          = @"phone";
static NSString *static_Argument_onLngLat       = @"onLngLat";
static NSString *static_Argument_offLngLat      = @"offLngLat";
static NSString *static_Argument_lineId         = @"lineId";
static NSString *static_Argument_returnData     = @"returnData";
static NSString *static_Argument_bcStationId    = @"bcStationId";
static NSString *static_Argument_customerName   = @"customerName";
static NSString *static_Argument_customerId     = @"customerId";
static NSString *static_Argument_beginDate      = @"beginDate";
static NSString *static_Argument_endDate        = @"endDate";
static NSString *static_Argument_vehTime        = @"vehTime";
static NSString *static_Argument_loginName      = @"loginName";
static NSString *static_Argument_loginCode      = @"loginCode";
static NSString *static_Argument_type           = @"type";
static NSString *static_Argument_content        = @"content";

static NSString * const EBPresentLoginVCDidFinishNotification = @"eb.present.login.present.finish";
static NSString * const EBLoginSuccessNotification = @"eb.login.success";
static NSString * const EBLogoutSuccessNotification = @"eb.logout.success";

#endif /* EBConfiguration_h */

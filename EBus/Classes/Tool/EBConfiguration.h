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

static NSString *static_Argument_onLngLat   = @"onLngLat";
static NSString *static_Argument_offLngLat  = @"offLngLat";
static NSString *static_Argument_lineId     = @"lineId";
static NSString *static_Argument_returnData = @"returnData";
static NSString *static_Argument_bcStationId =@"bcStationId";


static NSString * const EBPresentLoginVCDidFinishNotification = @"eb.present.login.present.finish";

#endif /* EBConfiguration_h */

//
//  WechatPayUtil.h
//  EBus
//
//  Created by Kowloon on 15/11/5.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatPayUtil : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

@end

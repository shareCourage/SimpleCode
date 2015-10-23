//
//  EBUserInfo.h
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface EBUserInfo : NSObject

singleton_interface(EBUserInfo)

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginId;

@end

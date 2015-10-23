//
//  EBUserInfo.m
//  EBus
//
//  Created by Kowloon on 15/10/23.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBUserInfo.h"

@implementation EBUserInfo
@synthesize loginName = _loginName;
@synthesize loginId = _loginId;

singleton_implementation(EBUserInfo)

- (NSString *)loginName {
    if (_loginName == nil) {
        _loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginNameForKey"];
    }
    return nil;
}

- (void)setLoginName:(NSString *)loginName {
    _loginName = loginName;
    [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:@"loginNameForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)loginId {
    if (_loginId == nil) {
        _loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginIdForKey"];
    }
    return _loginId;
}

- (void)setLoginId:(NSString *)loginId {
    _loginId = loginId;
    [[NSUserDefaults standardUserDefaults] setObject:loginId forKey:@"loginIdForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end

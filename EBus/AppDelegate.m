//
//  AppDelegate.m
//  EBus
//
//  Created by Kowloon on 15/10/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MAMapServices sharedServices].apiKey = static_KeyOfAMap;//高德地图key验证
    [AMapSearchServices sharedServices].apiKey = static_KeyOfAMap;//高德地图key验证
    [EBTool openAppInitial];//该app的启动验证
    NSString *version_eBus = EB_Version;
    [WXApi registerApp:static_WeChat_AppID withDescription:[NSString stringWithFormat:@"eBus%@",version_eBus]];//向微信注册
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    EBLog(@"Calling Application Bundle ID: %@", sourceApplication);//sourceApplication就是过来的bundle id
    EBLog(@"URL scheme:%@", [url scheme]);
    EBLog(@"URL query: %@", [url query]);
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"application->result = %@",resultDic);
        }];
        return YES;
    } else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {//需要填写微信的Bundle ID
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}


#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req {
    EBLog(@"~~~~~~%@",NSStringFromSelector(_cmd));
}
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp {
    EBLog(@"~~~~~~%@",NSStringFromSelector(_cmd));
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess://支付成功
                EBLog(@"WXSuccess");
                [[NSNotificationCenter defaultCenter] postNotificationName:EBWXPaySuccessNotification object:self];
                break;
            case WXErrCodeCommon ://通错误类型
                EBLog(@"WXErrCodeCommon");
                [self postEBWXPayFailureNotification];
                break;
            case WXErrCodeUserCancel://用户点击取消并返回
                EBLog(@"WXErrCodeUserCancel");
                [self postEBWXPayFailureNotification];
                break;
            case WXErrCodeSentFail://发送失败
                EBLog(@"WXErrCodeSentFail");
                [self postEBWXPayFailureNotification];
                break;
            case WXErrCodeAuthDeny://授权失败
                EBLog(@"WXErrCodeAuthDeny");
                [self postEBWXPayFailureNotification];
                break;
            case WXErrCodeUnsupport://微信不支持
                EBLog(@"WXErrCodeUnsupport");
                [self postEBWXPayFailureNotification];
                break;
            default:
                break;
        }
    }
}

- (void)postEBWXPayFailureNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:EBWXPayFailureNotification object:self];
}

@end







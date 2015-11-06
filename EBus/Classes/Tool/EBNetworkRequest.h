//
//  EBNetworkRequest.h
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^EBOptionDict)(NSDictionary *dict);
typedef void (^EBOptionError)(NSError *error);
typedef void (^EBOptionData)(NSData *data);

@interface EBNetworkRequest : NSObject

#pragma mark - NSDictionary
+ (AFHTTPRequestOperation *)GET:(NSString *)url
                     parameters:(id)parameters
                      dictBlock:(EBOptionDict)optionDict
                     errorBlock:(EBOptionError)optionError;

+ (AFHTTPRequestOperation *)GET:(NSString *)url
                     parameters:(id)parameters
                      dictBlock:(EBOptionDict)optionDict
                     errorBlock:(EBOptionError)optionError
               indicatorVisible:(BOOL)visible;

+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(EBOptionDict)optionDict
                      errorBlock:(EBOptionError)optionError;

+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(EBOptionDict)optionDict
                      errorBlock:(EBOptionError)optionError
                indicatorVisible:(BOOL)visible;


#pragma mark - NSData
+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                         success:(EBOptionData)optionData
                           error:(EBOptionError)optionError;

+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                         success:(EBOptionData)optionData
                           error:(EBOptionError)optionError
                indicatorVisible:(BOOL)visible;

@end

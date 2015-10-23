//
//  EBNetworkRequest.m
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBNetworkRequest.h"

@implementation EBNetworkRequest

+ (AFHTTPRequestOperation *)GET:(NSString *)url
                     parameters:(id)parameters
                      dictBlock:(EBOptionDict)optionDict
                     errorBlock:(EBOptionError)optionError
{
    return [self GET:url parameters:parameters dictBlock:optionDict errorBlock:optionError indicatorVisible:YES];
}

+ (AFHTTPRequestOperation *)GET:(NSString *)url
                     parameters:(id)parameters
                      dictBlock:(EBOptionDict)optionDict
                     errorBlock:(EBOptionError)optionError
               indicatorVisible:(BOOL)visible
{
    if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//将数据转化为NSData
    AFHTTPRequestOperation *operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (optionDict) optionDict(dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (optionError) optionError(error);
    }];
    return operation;
}

+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(EBOptionDict)optionDict
                      errorBlock:(EBOptionError)optionError
{
    return [self POST:url parameters:parameters dictBlock:optionDict errorBlock:optionError indicatorVisible:YES];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(EBOptionDict)optionDict
                      errorBlock:(EBOptionError)optionError
                indicatorVisible:(BOOL)visible
{
    if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//将数据转化为NSData
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (optionDict) optionDict(dict);
        if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (optionError) optionError(error);
        if (visible) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    return operation;
}

@end

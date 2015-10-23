//
//  EBLineDetail.h
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBLineDetail : NSObject

@property (nonatomic, copy) NSString *station;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *jid;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

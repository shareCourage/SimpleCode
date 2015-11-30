//
//  EBOrderDetailController.h
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
@class EBOrderSpecificModel;

@interface EBOrderDetailController : PHViewController

@property (nonatomic, strong) EBOrderSpecificModel *specificModel;
 
@property (nonatomic, assign) BOOL canFromMyOrder;



@end

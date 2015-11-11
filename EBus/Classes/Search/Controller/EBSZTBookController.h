//
//  EBSZTBookController.h
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"
@class EBSearchResultModel;

@interface EBSZTBookController : PHViewController

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) EBSearchResultModel *resultModel;
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, assign) BOOL hidenBookBtn;
@end

//
//  EBAttentionController.h
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"

@interface EBAttentionController : PHViewController

/*
 *  用来从其它根控制器跳转到该控制器，同时可以控制选择哪一个(已购、报名、跟团、我发起)
 */
@property (nonatomic, assign) NSUInteger titleSelectIndex;

@end

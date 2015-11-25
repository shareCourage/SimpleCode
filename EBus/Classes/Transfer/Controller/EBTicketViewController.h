//
//  EBTicketViewController.h
//  EBus
//
//  Created by Kowloon on 15/11/25.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTableViewController.h"
@class EBTransferModel;

@interface EBTicketViewController : PHTableViewController
@property (nonatomic, strong) EBTransferModel *transferModel;

@end

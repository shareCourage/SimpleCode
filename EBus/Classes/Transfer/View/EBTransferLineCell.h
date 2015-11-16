//
//  EBTransferLineCell.h
//  EBus
//
//  Created by Kowloon on 15/11/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseLineCell.h"
@class EBTransferLineCell, EBTransferModel;

typedef  NS_ENUM(NSUInteger, EBTicketType) {
    EBTicketTypeOfWaiting = 300,//待出票
    EBTicketTypeOfOut,//出票
    EBTicketTypeOfCheckLine,//查看路线
    EBTicketTypeOfTimeOut,//超时
    EBTicketTypeOfNone
};

@protocol EBTransferLineCellDelegate <NSObject>

@optional
- (void)transferLineOutTicktet:(EBTransferLineCell *)transeferLine transerModel:(EBTransferModel *)model type:(EBTicketType)type;

@end

@interface EBTransferLineCell : EBBaseLineCell

@property (nonatomic, weak) id <EBTransferLineCellDelegate> delegate;

@end

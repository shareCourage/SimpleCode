//
//  EBUsualLineCell.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBBaseLineCell.h"
@class EBUsualLineCell;

typedef  NS_ENUM(NSUInteger, EBSearchBuyType) {
    EBSearchBuyTypeOfNone = 1000,
    EBSearchBuyTypeOfBuy,
    EBSearchBuyTypeOfGroup,
    EBSearchBuyTypeOfSign,
};

@protocol EBUsualLineCellDelegate <NSObject>

@optional
- (void)usualLineDidClick:(EBUsualLineCell *)usualLine type:(EBSearchBuyType)type;

@end

@interface EBUsualLineCell : EBBaseLineCell


@property (nonatomic, weak) IBOutlet id <EBUsualLineCellDelegate>delegate;

@property (nonatomic, assign, getter=isShowBuyView) BOOL showBuyView;

@end

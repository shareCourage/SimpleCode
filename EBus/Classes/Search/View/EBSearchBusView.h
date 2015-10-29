//
//  EBSearchBusView.h
//  EBus
//
//  Created by Kowloon on 15/10/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBSearchBusView;

typedef  NS_ENUM(NSUInteger, EBSearchBusClickType) {
    EBSearchBusClickTypeNone = 100,
    EBSearchBusClickTypeMyPosition,
    EBSearchBusClickTypeEndPosition,
    EBSearchBusClickTypeStartTime,
    EBSearchBusClickTypeDeleteOfMyPosition,
    EBSearchBusClickTypeDeleteOfEndPosition,
    EBSearchBusClickTypeDeleteOfStartTime,
    EBSearchBusClickTypeExchange,
    EBSearchBusClickTypeSearch,
};
@protocol EBSearchBusViewDelegate <NSObject>

@optional
- (void)searchBusView:(EBSearchBusView *)searchBusView clickType:(EBSearchBusClickType)type;

@end

@interface EBSearchBusView : UIView

@property (weak , nonatomic) IBOutlet id <EBSearchBusViewDelegate> delegate;

@property (nonatomic, copy) NSString *myPositionTitle;

@property (nonatomic, copy) NSString *endPositionTitle;

@property (nonatomic, copy) NSString *startTimeTitle;

@property (nonatomic, assign) BOOL showStartTimeBtn;
@end

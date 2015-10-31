//
//  EBAttentionTableView.h
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSUInteger, EBAttentionType) {
    EBAttentionTypePurchase = 200,
    EBAttentionTypeSign,
    EBAttentionTypeGroup,
    EBAttentionTypeSponsor,
    EBAttentionTypeNone
};

@interface EBAttentionTableView : UIView

- (void)beginRefresh;

@end

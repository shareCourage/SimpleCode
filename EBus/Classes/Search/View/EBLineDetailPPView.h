//
//  EBLineDetailPPView.h
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBLineDetail.h"
@class EBLineDetailPPView;

@protocol EBLineDetailPPViewDelegate <NSObject>

@optional
- (void)lineDetailPPViewDidClickRightBtn:(EBLineDetailPPView *)ppView;

@end

@interface EBLineDetailPPView : UIView

+ (instancetype)lineDetailPPView;
@property (nonatomic, assign) id <EBLineDetailPPViewDelegate> delegate;
@property (nonatomic, strong) EBLineDetail *lineDetail;

@end

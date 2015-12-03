//
//  EBLineDetailPPView.h
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBLineDetailPPView, EBLineStation;

@protocol EBLineDetailPPViewDelegate <NSObject>

@optional
- (void)lineDetailPPViewCheckPhoto:(EBLineDetailPPView *)ppView lineDetail:(EBLineStation *)lineM;

@end

@interface EBLineDetailPPView : UIView

+ (instancetype)lineDetailPPView;
@property (nonatomic, assign) id <EBLineDetailPPViewDelegate> delegate;
@property (nonatomic, strong) EBLineStation *lineDetail;

@end

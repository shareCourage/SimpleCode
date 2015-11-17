//
//  EBTimeChooseView.h
//  EBus
//
//  Created by Kowloon on 15/11/17.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBTimeChooseView;
typedef  NS_ENUM(NSUInteger, EBTimeChooseViewClickType) {
    EBTimeChooseViewClickTypeOfCancel = 200000,
    EBTimeChooseViewClickTypeOfSure,
    EBTimeChooseViewClickTypeOfNone
};

@protocol EBTimeChooseViewDelegate <NSObject>

@optional
- (void)timeChooseView:(EBTimeChooseView *)pickerView didClickType:(EBTimeChooseViewClickType)type;
- (void)timeChooseView:(EBTimeChooseView *)pickerView didSelectTime:(NSString *)time;

@end

@interface EBTimeChooseView : UIView

@property(nonatomic, assign)id<EBTimeChooseViewDelegate>delegate;


@end

//
//  EBZJTypePickerView.h
//  EBus
//
//  Created by Kowloon on 15/11/12.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBZJTypePickerView;
typedef  NS_ENUM(NSUInteger, EBZJTypePickerViewClickType) {
    EBZJTypePickerViewClickTypeOfCancel = 200000,
    EBZJTypePickerViewClickTypeOfSure,
    EBZJTypePickerViewClickTypeOfNone
};
@protocol EBZJTypePickerViewDelegate <NSObject>

@optional
- (void)zj_typePickerView:(EBZJTypePickerView *)pickerView didSelected:(EBZJTypePickerViewClickType)type row:(NSUInteger)row string:(NSString *)string;

@end
@interface EBZJTypePickerView : UIView

@property(nonatomic, assign)id<EBZJTypePickerViewDelegate>delegate;

@end

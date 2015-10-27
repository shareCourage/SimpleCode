//
//  PHCalenderViewCell.h
//  SimpleCalendar
//
//  Created by Paul on 15-10-25.
//  Copyright (c) 2015年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PHCalenderViewCellStyle) {
    PHCalenderViewCellStyleDefault,
    PHCalenderViewCellStyleLeftRight,
    PHCalenderViewCellStyleUpDown
};

@interface PHCalenderViewCell : UIView

- (instancetype)initWithStyle:(PHCalenderViewCellStyle)style;
@property (nonatomic, assign, readonly) PHCalenderViewCellStyle cellStyle;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) UIColor *selectedColor;
@end

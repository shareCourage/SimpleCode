//
//  PHCalenderViewCell.m
//  SimpleCalendar
//
//  Created by Paul on 15-10-25.
//  Copyright (c) 2015年 Jason Lee. All rights reserved.
//

#import "PHCalenderViewCell.h"
#import "PHCalenderView.h"

@interface PHCalenderViewCell ()
@property (nonatomic, strong) UIColor *previousBgColor;
@end

@implementation PHCalenderViewCell

#pragma mark - 懒加载

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}



#pragma mark - Super Method
- (instancetype)init {
    self = [super init];
    if (self) {
        _cellStyle = PHCalenderViewCellStyleDefault;
    }
    return self;
}

- (instancetype)initWithStyle:(PHCalenderViewCellStyle)style {
    self = [super init];
    if (self) {
        _cellStyle = style;
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:contentView atIndex:0];
        self.contentView = contentView;
    }
    return self;
}


- (void)layoutSubviews {
    self.contentView.frame = self.bounds;
    switch (self.cellStyle) {
        case PHCalenderViewCellStyleDefault:
            [self defaultLayout];
            break;
        case PHCalenderViewCellStyleLeftRight:
            [self leftRightLayout];
            break;
        case PHCalenderViewCellStyleUpDown:
            [self upDownLayout];
            break;
        default:
            break;
    }
    if (self.contentView.subviews.count > 0) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self bringSubviewToFront:self.contentView];
        for (UIView *view in self.contentView.subviews) {
            view.frame = self.contentView.bounds;
        }
    }
    
}

- (void)defaultLayout {
    self.textLabel.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor clearColor];
}
- (void)leftRightLayout {
    if (self.detailLabel.text.length != 0) {
        self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);
        self.detailLabel.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
        self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        self.textLabel.frame = self.bounds;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}
- (void)upDownLayout {
    if (self.detailLabel.text.length != 0) {
        self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2);
        self.detailLabel.frame = CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2);
        self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        self.textLabel.frame = self.bounds;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Public
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.previousBgColor = self.backgroundColor;
        self.backgroundColor = self.selectedColor;
    } else {
        self.backgroundColor = self.previousBgColor;
    }
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithRed:129 / 255.f green:199 / 255.f blue:249 / 255.f alpha:1.f];
    }
    return _selectedColor;
}
@end





//
//  PHCalenderView.h
//  SimpleCalendar
//
//  Created by Paul on 15-10-25.
//  Copyright (c) 2015年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHCalenderView, PHCalenderViewCell;

@protocol PHCalenderViewDataSource <NSObject>

@required
- (NSUInteger)numberOfRowsInCalenderView:(PHCalenderView *)calenderView;
- (PHCalenderViewCell *)calenderView:(PHCalenderView *)calenderView cellForRow:(NSUInteger)row column:(NSUInteger)column;

@optional
- (CGFloat)heightForRowInCalenderView:(PHCalenderView *)calenderView;

@end


@protocol PHCalenderViewDelegate <NSObject>

@optional
- (void)calenderView:(PHCalenderView *)calenderView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column;

@end

@interface PHCalenderView : UIView

@property (nonatomic, weak) IBOutlet id <PHCalenderViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <PHCalenderViewDelegate> delegate;

@property (nonatomic, assign, getter = isAllowMultiSelect) BOOL allowMultiSelect;
- (PHCalenderViewCell *)cellForRow:(NSUInteger)row column:(NSUInteger)column;
- (NSUInteger)numberOfRows;
- (void)reloadData;
- (void)reloadDataAtRow:(NSUInteger)row column:(NSUInteger)column;

@end







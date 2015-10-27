//
//  PHCalenderView.m
//  SimpleCalendar
//
//  Created by Paul on 15-10-25.
//  Copyright (c) 2015年 Jason Lee. All rights reserved.
//

#define ColumnNumber 7
#define CellTag     1000
#import "PHCalenderView.h"
#import "PHCalenderViewCell.h"

@interface PHCalenderView ()
@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation PHCalenderView

- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [NSMutableArray arrayWithCapacity:self.rows * ColumnNumber];
    }
    return _cells;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common Init
- (void)commonInit {
    self.cellHeight = 50;
    self.cellWidth = self.bounds.size.width / ColumnNumber;
}

#pragma mark - Public Method
- (void)reloadData {
    if (self.dataSource == nil) return;
    self.rows = [self.dataSource numberOfRowsInCalenderView:self];
    if ([self.dataSource respondsToSelector:@selector(heightForRowInCalenderView:)]) {
        self.cellHeight = [self.dataSource heightForRowInCalenderView:self];
    }
    self.cellWidth = self.bounds.size.width / ColumnNumber;
    for (PHCalenderViewCell *cell in self.cells) {
        [cell removeFromSuperview];
    }
    self.cells = nil;
    NSUInteger tag = CellTag;
    for (NSUInteger i = 0; i < self.rows; ++i) {
        CGFloat y = i * self.cellHeight;
        for (NSUInteger j = 0; j < ColumnNumber; ++j) {
            CGFloat x = j * self.cellWidth;
            PHCalenderViewCell *cell = [self.dataSource calenderView:self cellForRow:i column:j];
            cell.row = i;
            cell.column = j;
            cell.tag = tag;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [cell addGestureRecognizer:tap];
            cell.frame = CGRectMake(x, y, self.cellWidth, self.cellHeight);
            [self addSubview:cell];
            [self.cells addObject:cell];
        }
    }
}
- (void)reloadDataAtRow:(NSUInteger)row column:(NSUInteger)column {
    
}
- (PHCalenderViewCell *)cellForRow:(NSUInteger)row column:(NSUInteger)column
{
    NSUInteger index = row * 7 + column;
    if (index > self.cells.count) return nil;
    return self.cells[index];
}

- (NSUInteger)numberOfRows {
    return self.rows;
}
#pragma mark - Private Method
- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    PHCalenderViewCell *cell = (PHCalenderViewCell *)gesture.view;
    if ([self.delegate respondsToSelector:@selector(calenderView:didSelectAtRow:column:)]) {
        [self.delegate calenderView:self didSelectAtRow:cell.row column:cell.column];
    }
    cell.selected = !cell.isSelected;
}

@end




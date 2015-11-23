//
//  EBTimeChooseView.m
//  EBus
//
//  Created by Kowloon on 15/11/17.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTimeChooseView.h"


@interface EBTimeChooseView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak)UIPickerView *myPickerView;
@property (nonatomic, weak)UIToolbar *myToolBar;
@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;

@property (nonatomic, copy) NSString *hourStr;
@property (nonatomic, copy) NSString *minStr;

@end

@implementation EBTimeChooseView

- (NSMutableArray *)dataSource1 {
    if (!_dataSource1) {
        _dataSource1 = [NSMutableArray array];
        for (NSInteger i = 0; i < 24; i ++) {
            NSString *string = [NSString stringWithFormat:@"%02ld",(long)i];
            [_dataSource1 addObject:string];
        }
    }
    return _dataSource1;
}

- (NSMutableArray *)dataSource2 {
    if (!_dataSource2) {
        _dataSource2 = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i ++) {
            NSString *string = [NSString stringWithFormat:@"%ld0",(long)i];
            [_dataSource2 addObject:string];
        }
    }
    return _dataSource2;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];
        cancel.tag = EBTimeChooseViewClickTypeOfCancel;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];
        
        done.tag = EBTimeChooseViewClickTypeOfSure;
        UIToolbar *tooBar = [[UIToolbar alloc] init];
        tooBar.barStyle = UIBarStyleDefault;
        tooBar.items = @[cancel, space, done];
        self.myToolBar = tooBar;
        [self addSubview:tooBar];
        
        UIPickerView *picker = [[UIPickerView alloc] init];
        picker.dataSource = self;
        picker.delegate = self;
        [self addSubview:picker];
        self.myPickerView = picker;
        [picker selectRow:7 inComponent:0 animated:NO];
        self.hourStr = @"07";
        self.minStr = @"00";
    }
    return self;
}
- (void)layoutSubviews
{
    CGFloat toolBarW = self.frame.size.width;
    CGFloat toolBarH = 30;
    self.myToolBar.frame = CGRectMake(0, 0, toolBarW, toolBarH);
    CGFloat datePickerY = toolBarH;
    CGFloat datePickerW = toolBarW;
    CGFloat datePickerH = self.frame.size.height - datePickerY;
    self.myPickerView.frame = CGRectMake(0, datePickerY, datePickerW, datePickerH);
}

- (void)barButtonClick:(UIBarButtonItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(timeChooseView:didClickType:)]) {
        [self.delegate timeChooseView:self didClickType:sender.tag];
    }
}
#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataSource1.count;
    } else if (component == 1) {
        return self.dataSource2.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataSource1[row];
    } else if (component == 1) {
        return self.dataSource2[row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.hourStr = self.dataSource1[row];
    } else if (component == 1) {
        self.minStr = self.dataSource2[row];
    }
    NSString *string = [NSString stringWithFormat:@"%@%@",self.hourStr,self.minStr];
    if ([self.delegate respondsToSelector:@selector(timeChooseView:didSelectTime:)]) {
        [self.delegate timeChooseView:self didSelectTime:string];
    }
}

@end

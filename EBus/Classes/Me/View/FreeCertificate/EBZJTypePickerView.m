
//
//  EBZJTypePickerView.m
//  EBus
//
//  Created by Kowloon on 15/11/12.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBZJTypePickerView.h"

@interface EBZJTypePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak)UIPickerView *myPickerView;
@property (nonatomic, weak)UIToolbar *myToolBar;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, assign) NSUInteger selectedRow;
@end

@implementation EBZJTypePickerView

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"《深圳市敬老优待证》",
                        @"《深圳暂住老年人免费乘车证》",
                        @"《残疾人证》",
                        @"《残疾人证》- 盲人",
                        @"《中国人民共和国残疾军人证》",
                        @"《中国人民共和国伤残人民警察证》",
                        @"《中国人民共和国伤残国家机关工作人员证》",
                        @"《中国人民共和国伤残民兵民工工作证》",
                        @"《中国人民共和国老干部离休荣誉证》",
                        @"《军官证》、《警官证》、《士兵证》",
                        @"实名制免费'深圳通'",];
    }
    return _dataSource;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
        for (NSUInteger i = 0; i < self.dataSource.count; i ++) {
            [_labels addObject:[self pickerLabel]];
        }
    }
    return _labels;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];
        cancel.tag = EBZJTypePickerViewClickTypeOfCancel;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];
        
        done.tag = EBZJTypePickerViewClickTypeOfSure;
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
    if (sender.tag == EBZJTypePickerViewClickTypeOfCancel) {
        if ([self.delegate respondsToSelector:@selector(zj_typePickerView:didSelected:row:string:)]) {
            [self.delegate zj_typePickerView:self didSelected:sender.tag row:self.selectedRow string:nil];
        }
    } else if (sender.tag == EBZJTypePickerViewClickTypeOfSure) {
        if ([self.delegate respondsToSelector:@selector(zj_typePickerView:didSelected:row:string:)]) {
            [self.delegate zj_typePickerView:self didSelected:sender.tag row:self.selectedRow string:self.dataSource[self.selectedRow]];
        }
    }
    
}
#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        EBLog(@"%@",NSStringFromSelector(_cmd));
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (UILabel *)pickerLabel {
    UILabel *pickerLabel = [[UILabel alloc] init];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    return pickerLabel;
}

@end

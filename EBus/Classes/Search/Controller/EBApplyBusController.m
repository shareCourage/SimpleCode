//
//  EBApplyBusController.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define Cell_UnableBackgroundColor EB_RGBColor(241, 241, 241)
#define Cell_BoughtBackgroundColor EB_RGBColor(230, 146, 35)
#define Cell_FullBackgroundColor   [UIColor redColor]
#define HeightOfCalender (EB_WidthOfScreen / 7)

#import "EBApplyBusController.h"
#import "EBUserInfo.h"
#import "EBColorView.h"
#import "PHCalenderKit.h"
#import "EBSearchResultModel.h"

@interface EBApplyBusController ()<PHCalenderViewDataSource, PHCalenderViewDelegate>

@property (nonatomic, weak) UIView *weekView;
@property (nonatomic, weak) PHCalenderView *calenderView;

@property (nonatomic, weak) UIButton *selectAllBtn;
@property (nonatomic, weak) UIButton *workDayBtn;
@property (nonatomic, weak) UIButton *holidayBtn;

@property (nonatomic, strong) NSMutableArray *selectDates;
@property (nonatomic, strong) NSMutableArray *status;

@end

@implementation EBApplyBusController

- (NSMutableArray *)selectDates {
    if (!_selectDates) {
        _selectDates = [NSMutableArray array];
    }
    return _selectDates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请加班";
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
    [self.calenderView reloadData];
    [self addLineRequest];
}
#pragma mark - Request
- (void)addLineRequest {
    NSUInteger numberOfWeek = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth];
    PHCalenderDay *beginDay = [EBUserInfo sharedEBUserInfo].calendarDays[0];
    PHCalenderDay *endDay   = [EBUserInfo sharedEBUserInfo].calendarDays[(numberOfWeek - 1) * 7 + 6];
    NSString *beginDate = [EBTool stringFromPHCalenderDay:beginDay];
    NSString *endDate = [EBTool stringFromPHCalenderDay:endDay];
    if (!self.resultModel.lineId || !self.resultModel.vehTime) return;
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parameters = @{static_Argument_customerName   : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_customerId     : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_lineId         : self.resultModel.lineId,
                                 static_Argument_vehTime        : self.resultModel.vehTime,
                                 static_Argument_beginDate      : beginDate,
                                 static_Argument_endDate        : endDate};
    [EBNetworkRequest GET:static_Url_AddLine parameters:parameters dictBlock:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = dict[static_Argument_returnCode];
        NSString *status = dict[static_Argument_status];
        if ([code integerValue] == 500) {
            NSArray *array = [NSArray seprateString:status characterSet:@","];
            self.status = [array mutableCopy];
#if 0
            [self.status removeAllObjects];
            for (int i = 0; i < 35; i ++) {
                if (i % 2 == 0) {
                    [self.status addObject:@"1"];
                } else {
                    [self.status addObject:@"-1"];
                }
            }
#endif
            [self.calenderView reloadData];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
- (void)applyRequest {
    NSString *newString = nil;
    if (self.selectDates.count == 0) {
        [MBProgressHUD showError:@"请选择申请加班日期" toView:self.view];
        return;
    } else if (self.selectDates.count == 1){
        newString = [self.selectDates firstObject];
    } else {
        NSArray *sortArray = [self.selectDates sortedArrayUsingSelector:@selector(compare:)];//升序排序
        newString = [EBTool stringConnected:sortArray connectString:@","];
        EBLog(@"%@",newString);
    }
    if (!self.resultModel.lineId || !self.resultModel.vehTime || !self.resultModel.startTime || !self.resultModel.onStationId || !self.resultModel.offGeogId) return;
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parameters = @{static_Argument_customerName   : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_customerId     : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_lineId         : self.resultModel.lineId,
                                 static_Argument_vehTime        : self.resultModel.vehTime,
                                 static_Argument_startTime      : self.resultModel.startTime,
                                 static_Argument_onStationId    : self.resultModel.onStationId,
                                 static_Argument_offStationId   : self.resultModel.offStationId,
                                 static_Argument_runDates       : newString};
    [EBNetworkRequest GET:static_Url_ApplyLine parameters:parameters dictBlock:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = dict[static_Argument_returnCode];
        if ([code integerValue] == 500) {
            [MBProgressHUD showSuccess:@"申请加班成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD showError:@"申请加班失败" toView:self.view];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"申请加班失败" toView:self.view];
    }];
}
#pragma mark - PHCalenderViewDataSource

- (NSUInteger)numberOfRowsInCalenderView:(PHCalenderView *)calenderView {
    
    NSUInteger day = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth];
    return day;
}
- (PHCalenderViewCell *)calenderView:(PHCalenderView *)calenderView cellForRow:(NSUInteger)row column:(NSUInteger)column {
    PHCalenderViewCell *cell = [[PHCalenderViewCell alloc] initWithStyle:PHCalenderViewCellStyleDefault];
    NSUInteger value = row * 7 + column;
    PHCalenderDay *calendarDay = [EBUserInfo sharedEBUserInfo].calendarDays[value];
    if (self.status.count != 0 && value < self.status.count) {
        NSString *status = self.status[value];
        NSInteger statusInt = [status integerValue];
        if (statusInt == 1) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.userInteractionEnabled = YES;
        } else if (statusInt == -1) {
            cell.textLabel.backgroundColor = Cell_UnableBackgroundColor;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled = NO;
        } else if (statusInt == -2) {
            cell.textLabel.backgroundColor = Cell_FullBackgroundColor;
            cell.userInteractionEnabled = NO;
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)calendarDay.day];
    
    if ([calendarDay isEqualTo:[EBUserInfo sharedEBUserInfo].currentCalendarDay]) {
        cell.textLabel.textColor = [UIColor colorWithRed:249.0/255 green:75.0/255 blue:0 alpha:1];
    }
    return cell;
}

- (CGFloat)heightForRowInCalenderView:(PHCalenderView *)calenderView {
    return HeightOfCalender;
}

- (void)calenderView:(PHCalenderView *)calenderView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column {
    NSUInteger value = row * 7 + column;
    PHCalenderDay *calendarDay = [EBUserInfo sharedEBUserInfo].calendarDays[value];
    PHCalenderViewCell *cell = [calenderView cellForRow:row column:column];
    NSString *text = [EBTool stringFromPHCalenderDay:calendarDay space:@"-"];
    if (cell.isSelected) {
        EBLog(@"row -> %ld,column -> %ld, %@", (unsigned long)row, (unsigned long)column, cell.textLabel.text);
        if (!text) return;
        [self.selectDates addObject:text];
    } else {
        NSUInteger i = 0;
        for (NSString *obj in self.selectDates) {
            if ([obj isEqualToString:text]) {
                [self.selectDates removeObjectAtIndex:i];
                break;
            }
            i ++;
        }
    }
    
    for (NSString *obj in self.selectDates) {
        EBLog(@"%@",obj);
    }
}
- (void)dateChooseClick:(UIButton *)sender {
    if (sender.tag == 3) {
        [self applyRequest];
    } 
}

#pragma mark - Private
- (void)commonInit {
    CGFloat width = EB_WidthOfScreen;
    CGFloat height = EB_HeightOfScreen;
    
    CGFloat yearX = 0;
    CGFloat yearY = 64;
    CGFloat yearW = width;
    CGFloat yearH = 20;
    CGRect yearF = CGRectMake(yearX, yearY, yearW, yearH);
    UILabel *yearMonth = [[UILabel alloc] initWithFrame:yearF];
    yearMonth.textAlignment = NSTextAlignmentCenter;
    yearMonth.textColor = EB_RGBColor(74, 125, 210);
    yearMonth.text = [NSString stringWithFormat:@"%@年%@月",@([EBUserInfo sharedEBUserInfo].currentCalendarDay.year),@([EBUserInfo sharedEBUserInfo].currentCalendarDay.month)];
    [self.view addSubview:yearMonth];
    
    CGFloat weekX = 0;
    CGFloat weekY = CGRectGetMaxY(yearMonth.frame);
    CGFloat weekW = width;
    CGFloat weekH = 15;
    CGRect weekF = CGRectMake(weekX, weekY, weekW, weekH);
    UIView *week = [[UIView alloc] initWithFrame:weekF];
    [self.view addSubview:week];
    self.weekView = week;
    NSArray *labelTitles = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (NSUInteger i = 0; i < 7; i ++) {
        CGFloat labelX = i * width / 7;
        CGFloat labelY = 0;
        CGFloat labelW = width / 7;
        CGFloat labelH = weekH;
        CGRect labelF = CGRectMake(labelX, labelY, labelW, labelH);
        UILabel *label = [[UILabel alloc] initWithFrame:labelF];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = labelTitles[i];
        if (i == 0 || i == 6) label.textColor = EB_RGBColor(74, 125, 210);
        [week addSubview:label];
    }
    
    CGFloat calenderX = 0;
    CGFloat calenderY = CGRectGetMaxY(week.frame);
    CGFloat calenderW = width;
    CGFloat calenderH = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth] * HeightOfCalender;
    CGRect calenderF = CGRectMake(calenderX, calenderY, calenderW, calenderH);
    PHCalenderView *calender = [[PHCalenderView alloc] initWithFrame:calenderF];
    calender.backgroundColor = EB_RGBColor(241, 241, 241);
    calender.dataSource = self;
    calender.delegate = self;
    [self.view addSubview:calender];
    self.calenderView = calender;
    
    CGFloat colorX = 0;
    CGFloat colorY = CGRectGetMaxY(calender.frame);
    CGFloat colorW = width;
    CGFloat colorH = 25;
    CGRect colorF = CGRectMake(colorX, colorY, colorW, colorH);
    EBColorView *colorView = [EBColorView colorViewFromXib];
    colorView.frame = colorF;
    colorView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:colorView];
    
#if 1 //需求暂时被搁置,将这个view隐藏起来
    CGFloat btnH = 30;
    CGFloat btnViewX = 0;
    CGFloat btnViewY = CGRectGetMaxY(colorView.frame);
    CGFloat btnViewW = width;
    CGFloat btnViewH = btnH;
    CGRect btnViewF = CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH);
    UIView *btnView = [[UIView alloc] initWithFrame:btnViewF];
    [self.view addSubview:btnView];
    btnView.hidden = YES;
    
    NSArray *btnTitle = @[@"全选",@"工作日",@"节假日"];
    for (NSUInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(dateChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.layer.cornerRadius = btnH / 2;
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:EB_RGBColor(156, 193, 86)];
        CGFloat padding = 10;
        CGFloat hhhh = padding * 3 * 2;//两边的距离
        CGFloat bW = (width - hhhh - padding * 2) / 3;
        CGFloat bX = padding * 3 + i * (bW + padding);
        CGFloat bY = 0;
        CGFloat bH = btnH;
        CGRect btnF = CGRectMake(bX, bY, bW, bH);
        btn.frame = btnF;
        [btnView addSubview:btn];
    }
#endif
    
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeSystem];
    apply.titleLabel.font = [UIFont systemFontOfSize:20];
    [apply setBackgroundColor:EB_DefaultColor];
    [apply setTitle:@"申请加班" forState:UIControlStateNormal];
    [apply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat wwwww = 30;//离左右两边的距离
    CGFloat applyW = width - wwwww * 2;
    CGFloat applyH = 50;
    CGFloat applyX = wwwww;
    CGFloat applyY = height - 20 - applyH;
    CGRect applyF = CGRectMake(applyX, applyY, applyW, applyH);
    apply.frame = applyF;
    apply.layer.cornerRadius = applyH / 2;
    apply.tag = 3;
    [apply addTarget:self action:@selector(dateChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:apply];
}


@end

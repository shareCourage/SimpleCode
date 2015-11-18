//
//  EBApplyBusController.m
//  EBus
//
//  Created by Kowloon on 15/10/30.
//  Copyright © 2015年 Goome. All rights reserved.
//
#warning 不清楚交互，暂时搁置，清楚需求后再做

#define HeightOfCalender (EB_WidthOfScreen / 7)

#import "EBApplyBusController.h"
#import "EBUserInfo.h"
#import "EBColorView.h"
#import "PHCalenderKit.h"

@interface EBApplyBusController ()<PHCalenderViewDataSource, PHCalenderViewDelegate>

@property (nonatomic, weak) UIView *weekView;
@property (nonatomic, weak) PHCalenderView *calenderView;

@property (nonatomic, weak) UIButton *selectAllBtn;
@property (nonatomic, weak) UIButton *workDayBtn;
@property (nonatomic, weak) UIButton *holidayBtn;

@end

@implementation EBApplyBusController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请加班";
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
    [self.calenderView reloadData];
}


- (void)dateChooseClick:(UIButton *)sender {
    if (sender.tag == 0) {
        
    } else if (sender.tag == 1) {
    
    } else if (sender.tag == 2) {
    
    } else if (sender.tag == 3) {
        
    }
}
#pragma mark - PHCalenderViewDataSource

- (NSUInteger)numberOfRowsInCalenderView:(PHCalenderView *)calenderView {
    
    NSUInteger day = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth];
    return day;
}
- (PHCalenderViewCell *)calenderView:(PHCalenderView *)calenderView cellForRow:(NSUInteger)row column:(NSUInteger)column {
    PHCalenderViewCell *cell = [[PHCalenderViewCell alloc] initWithStyle:PHCalenderViewCellStyleDefault];
    PHCalenderDay *calendarDay = [EBUserInfo sharedEBUserInfo].calendarDays[row * 7 + column];
    cell.textLabel.backgroundColor = EB_RGBColor(241, 241, 241);
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)calendarDay.day];
    if ([calendarDay isEqualTo:[EBUserInfo sharedEBUserInfo].currentCalendarDay]) {
        cell.textLabel.textColor = [UIColor colorWithRed:249.0/255 green:75.0/255 blue:0 alpha:1];
    }
    return cell;
}

- (CGFloat)heightForRowInCalenderView:(PHCalenderView *)calenderView {
    return HeightOfCalender;
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
    
    CGFloat btnH = 30;
    CGFloat btnViewX = 0;
    CGFloat btnViewY = CGRectGetMaxY(colorView.frame);
    CGFloat btnViewW = width;
    CGFloat btnViewH = btnH;
    CGRect btnViewF = CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH);
    UIView *btnView = [[UIView alloc] initWithFrame:btnViewF];
    [self.view addSubview:btnView];
    
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

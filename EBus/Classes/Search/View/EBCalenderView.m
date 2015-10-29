//
//  EBCalenderView.m
//  EBus
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define Cell_UnableBackgroundColor EB_RGBColor(241, 241, 241)
#define Cell_BoughtBackgroundColor EB_RGBColor(230, 146, 35)
#define Cell_FullBackgroundColor   [UIColor redColor]
#import "EBCalenderView.h"
#import "EBUserInfo.h"
#import "EBColorView.h"
#import "EBPriceView.h"

@interface EBCalenderView () <PHCalenderViewDataSource, PHCalenderViewDelegate>

@property (nonatomic, weak) PHCalenderView *calenderView;
@property (nonatomic, weak) UIView *weekView;
@property (nonatomic, weak) EBPriceView *priceView;
@property (nonatomic, weak) UIButton *addBusBtn;
@property (nonatomic, weak) UIButton *buyBtn;

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) NSArray *tickets;

@property (nonatomic, strong) NSMutableArray *selectPrices;
@end

@implementation EBCalenderView
- (NSMutableArray *)selectPrices {
    if (!_selectPrices) {
        _selectPrices = [NSMutableArray array];
    }
    return _selectPrices;
}

- (void)setPriceAndTicket:(NSDictionary *)priceAndTicket {
    _priceAndTicket = priceAndTicket;
    NSString *dayString = priceAndTicket[@"dayString"];
    NSString *price = priceAndTicket[@"prices"];
    NSString *ticket = priceAndTicket[@"tickets"];
    self.days = [NSArray seprateString:dayString characterSet:@","];
    self.prices = [NSArray seprateString:price characterSet:@","];
    self.tickets = [NSArray seprateString:ticket characterSet:@","];
}

#pragma mark - Super Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit:frame];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit:self.frame];
    }
    return self;
}


- (void)addBusClick {
    if ([self.delegate respondsToSelector:@selector(eb_calenderViewDidApply:)]) {
        [self.delegate eb_calenderViewDidApply:self];
    }
}
- (void)buyBtnClick {
    if ([self.delegate respondsToSelector:@selector(eb_calenderView:didOrder:)]) {
        [self.delegate eb_calenderView:self didOrder:self.selectPrices];
    }
}
#pragma mark - Public Method

- (void)reloadData {
    [self.calenderView reloadData];
}

#pragma mark - PHCalenderViewDataSource

- (NSUInteger)numberOfRowsInCalenderView:(PHCalenderView *)calenderView {
    
    NSUInteger day = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth];
    return day;
}
- (PHCalenderViewCell *)calenderView:(PHCalenderView *)calenderView cellForRow:(NSUInteger)row column:(NSUInteger)column {
    PHCalenderViewCell *cell = nil;
    PHCalenderDay *calendarDay = [EBUserInfo sharedEBUserInfo].calendarDays[row * 7 + column];
    BOOL first = calendarDay.month != [EBUserInfo sharedEBUserInfo].currentCalendarDay.month;
    BOOL second = calendarDay.day < [EBUserInfo sharedEBUserInfo].currentCalendarDay.day;
    if (first || second) {
        cell = [[PHCalenderViewCell alloc] initWithStyle:PHCalenderViewCellStyleDefault];
        cell.textLabel.backgroundColor = Cell_UnableBackgroundColor;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.userInteractionEnabled = NO;
    } else {
        cell = [[PHCalenderViewCell alloc] initWithStyle:PHCalenderViewCellStyleUpDown];
        cell.userInteractionEnabled = NO;
        NSUInteger index = calendarDay.day - [EBUserInfo sharedEBUserInfo].currentCalendarDay.day;
        cell.detailLabel.font = [UIFont systemFontOfSize:13];
        if (index < self.tickets.count) {
            NSString *ticket = self.tickets[index];
            NSString *title = nil;
            if ([ticket integerValue] == -2) {
                title = @"已购";
                cell.backgroundColor = Cell_BoughtBackgroundColor;
            } else if ([ticket integerValue] == 0) {
                title = @"已满";
                cell.backgroundColor = Cell_FullBackgroundColor;
            } else if ([ticket integerValue] == -1) {
                cell.backgroundColor = Cell_UnableBackgroundColor;
            } else {
                title = [NSString stringWithFormat:@"余%@",ticket];
                cell.userInteractionEnabled = YES;
            }
            cell.detailLabel.text = title;
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)calendarDay.day];
    if ([calendarDay isEqualTo:[EBUserInfo sharedEBUserInfo].currentCalendarDay]) {
        cell.textLabel.textColor = [UIColor colorWithRed:249.0/255 green:75.0/255 blue:0 alpha:1];
    }
    return cell;
}

- (CGFloat)heightForRowInCalenderView:(PHCalenderView *)calenderView {
    return 50;
}

- (void)calenderView:(PHCalenderView *)calenderView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column {
    PHCalenderViewCell *cell = [calenderView cellForRow:row column:column];
    if (cell.isSelected) {
        NSLog(@"row -> %ld,column -> %ld, %@", (unsigned long)row, (unsigned long)column, cell.textLabel.text);
        [self.selectPrices addObject:cell.textLabel.text];
    } else {
        NSUInteger i = 0;
        for (NSString *obj in self.selectPrices) {
            if ([obj isEqualToString:cell.textLabel.text]) {
                [self.selectPrices removeObjectAtIndex:i];
                break;
            }
            i ++;
        }
    }
}

#pragma mark - Private
- (void)commonInit:(CGRect)frame {
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat yearX = 0;
    CGFloat yearY = 0;
    CGFloat yearW = width;
    CGFloat yearH = 30;
    CGRect yearF = CGRectMake(yearX, yearY, yearW, yearH);
    UILabel *yearMonth = [[UILabel alloc] initWithFrame:yearF];
    yearMonth.textAlignment = NSTextAlignmentCenter;
    yearMonth.text = [NSString stringWithFormat:@"%@年%@月",@([EBUserInfo sharedEBUserInfo].currentCalendarDay.year),@([EBUserInfo sharedEBUserInfo].currentCalendarDay.month)];
    [self addSubview:yearMonth];
    
    CGFloat weekX = 0;
    CGFloat weekY = CGRectGetMaxY(yearMonth.frame);
    CGFloat weekW = width;
    CGFloat weekH = 20;
    CGRect weekF = CGRectMake(weekX, weekY, weekW, weekH);
    UIView *week = [[UIView alloc] initWithFrame:weekF];
    [self addSubview:week];
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
    CGFloat calenderH = [[EBUserInfo sharedEBUserInfo].currentDate numberOfWeeksInCurrentMonth] * 50;
    CGRect calenderF = CGRectMake(calenderX, calenderY, calenderW, calenderH);
    PHCalenderView *calender = [[PHCalenderView alloc] initWithFrame:calenderF];
    calender.dataSource = self;
    calender.delegate = self;
    [self addSubview:calender];
    self.calenderView = calender;
    
    CGFloat btnH = 50;
    
    CGFloat bottomX = 0;
    CGFloat bottomY = CGRectGetMaxY(calender.frame);
    CGFloat bottomW = width;
    CGFloat bottomH = height - bottomY;
    CGRect bottomF = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomF];
    [self addSubview:bottomView];
    
    CGFloat colorX = 0;
    CGFloat colorY = 0;
    CGFloat colorW = width;
    CGFloat colorH = 50;
    CGRect colorF = CGRectMake(colorX, colorY, colorW, colorH);
    EBColorView *colorView = [EBColorView colorViewFromXib];
    colorView.frame = colorF;
    colorView.backgroundColor = [UIColor purpleColor];
    [bottomView addSubview:colorView];
    
    CGFloat priceX = 0;
    CGFloat priceY = colorH;
    CGFloat priceW = width;
    CGFloat priceH = bottomH - btnH - colorH - 10;
    CGRect priceF = CGRectMake(priceX, priceY, priceW, priceH);
    EBPriceView *price = [EBPriceView priceViewFromXib];
    price.frame = priceF;
    price.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:price];
    self.priceView = price;
    
    CGFloat btnViewX = 0;
    CGFloat btnViewY = CGRectGetMaxY(price.frame);
    CGFloat btnViewW = width;
    CGFloat btnViewH = btnH;
    CGRect btnViewF = CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH);
    UIView *btnView = [[UIView alloc] initWithFrame:btnViewF];
    [bottomView addSubview:btnView];
    
    CGFloat addBX = 20;
    CGFloat addBY = 0;
    CGFloat addBW = width / 3 - 20;
    CGFloat addBH = btnViewH;
    CGRect addBF = CGRectMake(addBX, addBY, addBW, addBH);
    UIButton *addB = [UIButton buttonWithFrame:addBF target:self action:@selector(addBusClick) normalImage:nil title:@"我要加车"];
    [addB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addB.backgroundColor = EB_RGBColor(156, 193, 85);
    [btnView addSubview:addB];
    addB.layer.cornerRadius = addBH / 2;
    self.addBusBtn = addB;
    
    CGFloat buyBX = CGRectGetMaxX(addB.frame) + 20;
    CGFloat buyBY = 0;
    CGFloat buyBW = width * 2 / 3 -  40;
    CGFloat buyBH = btnViewH;
    CGRect buyBF = CGRectMake(buyBX, buyBY, buyBW, buyBH);
    UIButton *buyB = [UIButton buttonWithFrame:buyBF target:self action:@selector(buyBtnClick) normalImage:nil title:@"购买"];
    buyB.backgroundColor = EB_RGBColor(156, 196, 236);
    [buyB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView addSubview:buyB];
    buyB.layer.cornerRadius = buyBH / 2;
    self.buyBtn = buyB;
}
@end

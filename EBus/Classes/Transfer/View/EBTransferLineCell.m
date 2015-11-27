//
//  EBTransferLineCell.m
//  EBus
//
//  Created by Kowloon on 15/11/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTransferLineCell.h"
#import <Masonry/Masonry.h>
#import "EBTransferModel.h"

@interface EBTransferLineCell ()
@property (nonatomic, weak) UIView *priceView;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UIButton *ticketDisplayBtn;
@property (nonatomic, weak) UILabel *tipL;

@property (nonatomic, assign) EBTicketType type;
@end

@implementation EBTransferLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBTransferLineCell";
    EBTransferLineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBTransferLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self labelImplementation];
    }
    return self;
}

- (void)labelImplementation {
    UIView *priceView = [[UIView alloc] init];
    UILabel *price = [[UILabel alloc] init];
    UIButton *ticketOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [ticketOut addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    [ticketOut.titleLabel setSystemFontOf15];
    [ticketOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ticketOut.layer.cornerRadius = 15;
    price.textAlignment = NSTextAlignmentRight;
    
    [priceView addSubview:price];
    [priceView addSubview:ticketOut];
    [self.contentView addSubview:priceView];
    self.priceView = priceView;
    self.priceL = price;
    self.ticketDisplayBtn = ticketOut;
    
    UILabel *tip = [[UILabel alloc] init];
    [self.contentView addSubview:tip];
    [tip setSystemFontOf10];
    tip.textAlignment = NSTextAlignmentRight;
    tip.textColor = [UIColor lightGrayColor];
    tip.text = @"乘车前30分钟可出票";
    self.tipL = tip;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    EB_WS(ws);
    CGFloat width = 75;
    CGFloat height = 60;
    CGFloat right = 20;
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.height.mas_equalTo(@(height));//高度
        make.width.mas_equalTo(@(width));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-right);//离父控件右边
    }];
    
    
    CGFloat priceW = width;
    CGFloat priceH = height / 2;
    CGFloat priceX = 0;
    CGFloat priceY = self.ticketDisplayBtn.hidden ? 10 : 0;
    self.priceL.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat strickoutPriceW = width;
    CGFloat strickoutPriceH = height / 2;
    CGFloat strickoutPriceX = 3;
    CGFloat strickoutPriceY = CGRectGetMaxY(self.priceL.frame);
    self.ticketDisplayBtn.frame = CGRectMake(strickoutPriceX, strickoutPriceY, strickoutPriceW, strickoutPriceH);
   
    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(15));//高度
        make.width.mas_equalTo(@(200));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-right);//离父控件右边
        make.bottom.equalTo(ws.mas_bottom).with.offset(-5);//离父控件右边
    }];
}

- (void)outClick {//出票按钮
    EBLog(@"outClick");
    if ([self.delegate respondsToSelector:@selector(transferLineOutTicktet:transerModel:type:)]) {
        EBTransferModel *model = (EBTransferModel *)self.model;
        [self.delegate transferLineOutTicktet:self transerModel:model type:self.type];
    }
}

- (void)setModel:(EBBaseModel *)model {
    [super setModel:model];
    if ([model isKindOfClass:[EBTransferModel class]]) {
        EBTransferModel *tranferModel = (EBTransferModel *)model;
#if DEBUG
//        tranferModel.runDate = @"2015-11-26";
//        tranferModel.startTime = @"1210";
#else
#endif
        [self setupUI:tranferModel];
        [self setupData:tranferModel];
    }
}

- (void)setupUI:(EBTransferModel *)tranferModel {
    NSArray *array = [NSArray seprateString:tranferModel.runDate characterSet:@"-"];
    if (array.count != 3) return;
    NSString *dayStr = [array lastObject];
    NSString *hourMinute = [tranferModel.startTime insertSymbolString:@":" atIndex:2];
    NSArray *array2 = [hourMinute componentsSeparatedByString:@":"];
    if (array2.count != 2) return;
    NSString *hourStr = [array2 firstObject];
    NSString *minuteStr = [array2 lastObject];
    NSInteger day = [dayStr integerValue];
    NSInteger hour = [hourStr integerValue];
    NSInteger minute = [minuteStr integerValue];//08:40
    if ([EBTool currentDay] <= day) {
        if ([EBTool currentDay] == day) {
            if ([EBTool currentHour] <= hour) {
                if ([EBTool currentHour] == hour) {
                    if ([EBTool currentMinute] <= minute) {
                        //在没有超时的情况下，才存在判断的可能
                        if ( (minute - [EBTool currentMinute]) <= 30) {
                            self.type = EBTicketTypeOfOut;//出票
                        } else {
                            self.type = EBTicketTypeOfWaiting;
                        }
                    } else {
                        self.type = EBTicketTypeOfTimeOut;
                    }
                } else if ([EBTool currentHour] == hour - 1) {//8:20
                    if (minute >= 30) {
                        self.type = EBTicketTypeOfWaiting;
                    } else {
                        NSInteger time = 60 - [EBTool currentMinute];
                        if ((time + minute) <= 30) {
                            self.type = EBTicketTypeOfOut;
                        } else {
                            self.type = EBTicketTypeOfWaiting;
                        }
                    }
                } else {
                    self.type = EBTicketTypeOfWaiting;
                }
            } else {
                self.type = EBTicketTypeOfTimeOut;
            }
        } else {
            self.type = EBTicketTypeOfWaiting;
        }
        
    } else {
        self.type = EBTicketTypeOfTimeOut;
    }
}


- (void)setupData:(EBTransferModel *)orderModel {
    if ([orderModel.isFree boolValue]) {
        self.priceL.text = @"￥0.0元";
    } else {
        self.priceL.text = [NSString stringWithFormat:@"￥%.1f元",[orderModel.tradePrice floatValue]];
    }
}

- (void)setType:(EBTicketType)type {
    _type = type;
    EBTransferModel *tranferModel = (EBTransferModel *)self.model;
    if (self.type == EBTicketTypeOfOut) {
        self.ticketDisplayBtn.enabled = YES;
        [self.ticketDisplayBtn setTitle:@"出票" forState:UIControlStateNormal];
        [self.ticketDisplayBtn setBackgroundColor:EB_RGBColor(155, 194, 80)];
        if (tranferModel.vehCode.length != 0) {
            self.tipL.text = [NSString stringWithFormat:@"%@",tranferModel.vehCode];
            self.tipL.textColor = [UIColor lightGrayColor];
        } else {
            self.tipL.text = nil;
        }
    } else if (self.type == EBTicketTypeOfWaiting) {
        if (tranferModel.vehCode.length != 0) {
            self.ticketDisplayBtn.enabled = NO;
            [self.ticketDisplayBtn setTitle:tranferModel.vehCode forState:UIControlStateNormal];
            self.ticketDisplayBtn.backgroundColor = [UIColor whiteColor];
            [self.ticketDisplayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.tipL.text = @"乘车前30分钟可出票";
            self.tipL.textColor = [[UIColor redColor] colorWithAlphaComponent:0.7f];
        } else {
            self.ticketDisplayBtn.enabled = YES;
            [self.ticketDisplayBtn setTitle:@"待出票" forState:UIControlStateNormal];
            [self.ticketDisplayBtn setBackgroundColor:EB_RGBColor(155, 194, 80)];
            [self.ticketDisplayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.tipL.text = nil;
        }
        
    } else if (self.type == EBTicketTypeOfTimeOut){
        [self.ticketDisplayBtn setTitle:@"超时" forState:UIControlStateNormal];
        [self.ticketDisplayBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.ticketDisplayBtn.enabled = NO;
    }
}


@end

//
//  EBSearchBusView.m
//  EBus
//
//  Created by Kowloon on 15/10/14.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_HeightOfButton 50
#define EB_WidthOfButton (EB_WidthOfScreen > 320 ? 300 : 270)
#define EB_PaddingOfSearchBusView 10
#import "EBSearchBusView.h"
#import "EBSearchBusButton.h"
#import <Masonry/Masonry.h>

@interface EBSearchBusView ()

@property (nonatomic, weak) EBSearchBusButton *myPositionBtn;
@property (nonatomic, weak) EBSearchBusButton *endPositionBtn;
@property (nonatomic, weak) EBSearchBusButton *startTimeBtn;

@property (nonatomic, weak) UIButton *myPositionDeleteBtn;
@property (nonatomic, weak) UIButton *endPositionDeleteBtn;
@property (nonatomic, weak) UIButton *startTimeDeleteBtn;

@property (nonatomic, weak) UIButton *exchangeBtn;
@property (nonatomic, weak) UIButton *searchBtn;

@end

@implementation EBSearchBusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self searchBusButtonImplementation];
        [self exchangeButtonImplementation];
        [self searchBtnImplementation];
        [self startTimeButtonImplementation];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self searchBusButtonImplementation];
        [self exchangeButtonImplementation];
        [self searchBtnImplementation];
        [self startTimeButtonImplementation];
    }
    return self;
}
#pragma mark - Implementation
- (void)searchBusButtonImplementation {
    EBSearchBusButton *searchBtnOne = [self searchBusButtonWithTitle:@"出发地" normalImageName:@"search_myPosition"];
    EBSearchBusButton *searchBtnTwo = [self searchBusButtonWithTitle:@"目的地" normalImageName:@"search_endPosition"];
    searchBtnOne.tag = EBSearchBusClickTypeMyPosition;
    searchBtnTwo.tag = EBSearchBusClickTypeEndPosition;
    
    UIButton *deleteOne = [self deleteBtn];
    UIButton *deleteTwo = [self deleteBtn];
    deleteOne.tag = EBSearchBusClickTypeDeleteOfMyPosition;
    deleteTwo.tag = EBSearchBusClickTypeDeleteOfEndPosition;
    
    [searchBtnOne addSubview:deleteOne];
    [searchBtnTwo addSubview:deleteTwo];
    
    [self addSubview:searchBtnOne];
    [self addSubview:searchBtnTwo];
    
    self.myPositionBtn = searchBtnOne;
    self.endPositionBtn = searchBtnTwo;
    self.myPositionDeleteBtn = deleteOne;
    self.endPositionDeleteBtn = deleteTwo;
}

- (void)exchangeButtonImplementation {
    UIButton *exchange = [UIButton buttonWithType:UIButtonTypeCustom];
    exchange.imageView.contentMode = UIViewContentModeCenter;
    [exchange setImage:[UIImage imageNamed:@"search_exchange"] forState:UIControlStateNormal];
    [exchange addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    exchange.tag = EBSearchBusClickTypeExchange;
    [self addSubview:exchange];
    self.exchangeBtn = exchange;
}

- (void)searchBtnImplementation {
    UIButton *search = [UIButton eb_buttonWithTitle:@"查询班车"];
    search.tag = EBSearchBusClickTypeSearch;
    [search addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:search];
    self.searchBtn = search;
}

- (void)startTimeButtonImplementation {
    EBSearchBusButton *starBtn = [self searchBusButtonWithTitle:@"出发时间" normalImageName:@"search_startTime"];
    starBtn.tag = EBSearchBusClickTypeStartTime;
    
    UIButton *deleteOne = [self deleteBtn];
    deleteOne.tag = EBSearchBusClickTypeDeleteOfStartTime;
    
    [starBtn addSubview:deleteOne];
    [self addSubview:starBtn];
    self.startTimeBtn = starBtn;
    self.startTimeDeleteBtn = deleteOne;
}

#pragma mark - Private Method
- (EBSearchBusButton *)searchBusButtonWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName {
    EBSearchBusButton *searchBtn = [EBSearchBusButton searchBusButtonWithTitle:title];
    searchBtn.layer.cornerRadius = EB_HeightOfButton / 2;
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = EB_RGBAColor(199, 204, 215, 0.7).CGColor;
    [searchBtn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return searchBtn;
}

- (UIButton *)deleteBtn {
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return delete;
}

- (void)searchBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case EBSearchBusClickTypeDeleteOfMyPosition:
            self.myPositionTitle = nil;
            break;
        case EBSearchBusClickTypeDeleteOfEndPosition:
            self.endPositionTitle = nil;
            break;
        case EBSearchBusClickTypeDeleteOfStartTime:
            self.startTimeTitle = nil;
            break;
        case EBSearchBusClickTypeExchange:
        {
            NSString *title = self.myPositionTitle;
            self.myPositionTitle = self.endPositionTitle;
            self.endPositionTitle = title;
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(searchBusView:clickType:)]) {
        [self.delegate searchBusView:self clickType:sender.tag];
    }
}

#pragma mark - DidMoveToSuperView
- (void)didMoveToSuperview {
    [self positionBtnAutoLayout];
    [self exchangeBtnAutoLayout];
    [self searchBtnAutoLayout];
}

- (void)positionBtnAutoLayout {
    EB_WS(ws);
    CGFloat padding = EB_PaddingOfSearchBusView;
    CGFloat width = EB_WidthOfButton;
    CGFloat height = EB_HeightOfButton;
    [self.myPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.top.equalTo(ws).with.offset(padding + 10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.endPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.top.equalTo(self.myPositionBtn.mas_bottom).with.offset(padding);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.myPositionDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.myPositionBtn).with.offset(0);
        make.right.equalTo(ws.myPositionBtn).with.offset(0);
        make.height.mas_equalTo(height);//高度
        make.width.mas_equalTo(height);//宽度
    }];
    
    [self.endPositionDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.endPositionBtn).with.offset(0);
        make.right.equalTo(ws.endPositionBtn).with.offset(0);
        make.height.mas_equalTo(height);//高度
        make.width.mas_equalTo(height);//宽度
    }];
    
    if (self.showStartTimeBtn) {
        [self.startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.equalTo(self.endPositionBtn.mas_bottom).with.offset(padding);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        [self.startTimeDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.startTimeBtn).with.offset(0);
            make.right.equalTo(ws.startTimeBtn).with.offset(0);
            make.height.mas_equalTo(height);//高度
            make.width.mas_equalTo(height);//宽度
        }];
        [self.searchBtn setTitle:@"发起线路" forState:UIControlStateNormal];
    }
}

- (void)exchangeBtnAutoLayout {
    EB_WS(ws);
    CGFloat width = 30;
    CGFloat height = 40;
    CGFloat padding = EB_PaddingOfSearchBusView;
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).with.offset(padding / 2 + EB_HeightOfButton + padding * 2 - height / 2);
        make.left.equalTo(ws.myPositionBtn.mas_right).with.offset(-8);
        make.height.mas_equalTo(height);//高度
        make.width.mas_equalTo(width);//宽度
    }];
}

- (void)searchBtnAutoLayout {
    EB_WS(ws);
    CGFloat padding = EB_PaddingOfSearchBusView;
    CGFloat width = EB_WidthOfButton;
    CGFloat height = EB_HeightOfButton;
    if (self.showStartTimeBtn) {
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.equalTo(self.startTimeBtn.mas_bottom).with.offset(padding + 20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    } else {
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.equalTo(self.endPositionBtn.mas_bottom).with.offset(padding);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    }
}

#pragma mark - Public Method 
- (void)setMyPositionTitle:(NSString *)myPositionTitle {
    _myPositionTitle = myPositionTitle;
    if (myPositionTitle.length != 0) {
        [self.myPositionBtn setTitle:myPositionTitle forState:UIControlStateNormal];
        [self.myPositionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.myPositionBtn setTitle:@"出发地" forState:UIControlStateNormal];
        [self.myPositionBtn setTitleColor:EB_RGBColor(199, 204, 215) forState:UIControlStateNormal];
    }
}

- (void)setEndPositionTitle:(NSString *)endPositionTitle {
    _endPositionTitle = endPositionTitle;
    if (endPositionTitle.length != 0) {
        [self.endPositionBtn setTitle:endPositionTitle forState:UIControlStateNormal];
        [self.endPositionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.endPositionBtn setTitle:@"目的地" forState:UIControlStateNormal];
        [self.endPositionBtn setTitleColor:EB_RGBColor(199, 204, 215) forState:UIControlStateNormal];
    }
    
}


- (void)setStartTimeTitle:(NSString *)startTimeTitle {
    _startTimeTitle = startTimeTitle;
    if (startTimeTitle.length != 0) {
        [self.startTimeBtn setTitle:startTimeTitle forState:UIControlStateNormal];
        [self.startTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.startTimeBtn setTitle:@"出发时间" forState:UIControlStateNormal];
        [self.startTimeBtn setTitleColor:EB_RGBColor(199, 204, 215) forState:UIControlStateNormal];
    }
    
}
@end












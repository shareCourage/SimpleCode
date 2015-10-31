//
//  EBUsualLineCell.m
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_BuyColor     EB_RGBColor(156, 193, 85)
#define EB_GroupColor   EB_RGBColor(225, 130, 131)
#define EB_SignColor    EB_RGBColor(234, 172, 70)


#import "EBUsualLineCell.h"
#import <Masonry/Masonry.h>
#import "EBSearchResultModel.h"
#import "EBBoughtModel.h"

@interface EBUsualLineCell ()

@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, weak) UIView *priceView;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UILabel *strickoutPriceL;

@property (nonatomic, assign) EBSearchBuyType buyType;

@end

@implementation EBUsualLineCell

- (UIButton *)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.frame = CGRectMake(0, 0, 50, 50);
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:19]];
        _buyBtn.layer.cornerRadius = CGRectGetWidth(_buyBtn.frame) / 2;
        [_buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}
- (void)buyClick {
    if ([self.delegate respondsToSelector:@selector(usualLineDidClick:type:)]) {
        [self.delegate usualLineDidClick:self type:self.buyType];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBUsualLineCell";
    EBUsualLineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBUsualLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self labelImplementation];
        self.showBuyView = YES;
    }
    return self;
}

- (void)labelImplementation {
    UIView *priceView = [[UIView alloc] init];
    UILabel *price = [[UILabel alloc] init];
    UILabel *strickOut = [[UILabel alloc] init];
    strickOut.font = [UIFont systemFontOfSize:11];
    
    price.text = @"price";
    strickOut.text = @"strick";
    
    [priceView addSubview:price];
    [priceView addSubview:strickOut];
    [self.contentView addSubview:priceView];
    self.priceView = priceView;
    self.priceL = price;
    self.strickoutPriceL = strickOut;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    EB_WS(ws);
    CGFloat right = (self.isShowBuyView && self.model) ?  80 : 20;
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.height.mas_equalTo(@(50));//高度
        make.width.mas_equalTo(@(50));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-right);//离父控件右边
    }];
    
    CGFloat priceW = 60;
    CGFloat priceH = 30;
    CGFloat priceX = 0;
    CGFloat priceY = 0;
    self.priceL.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat strickoutPriceW = 60;
    CGFloat strickoutPriceH = 20;
    CGFloat strickoutPriceX = 0;
    CGFloat strickoutPriceY = CGRectGetMaxY(self.priceL.frame);
    self.strickoutPriceL.frame = CGRectMake(strickoutPriceX, strickoutPriceY, strickoutPriceW, strickoutPriceH);
}

- (void)setModel:(id)model {
    if (!model) return;
    _model = model;
    [self setUpData:model];
    [self setUpUI:model];
}

- (void)setUpData:(id)model {
    if ([model isKindOfClass:[EBSearchResultModel class]]) {
        EBSearchResultModel *result = model;
        self.priceL.text = [NSString stringWithFormat:@"￥%@元",result.tradePrice];
#warning 根据具体需求，具体更改
        if ([result.tradePrice floatValue] != [result.price floatValue]) {
            self.strickoutPriceL.hidden = YES;
            self.strickoutPriceL.attributedText = nil;
        } else {
            self.strickoutPriceL.hidden = NO;
            self.strickoutPriceL.attributedText = [self attributedString:[NSString stringWithFormat:@"￥%@元",result.price]];
        }
        self.departPointL.text = result.onStationName;
        self.endPointL.text = result.offStationName;
        self.totalTimeL.text = [NSString stringWithFormat:@"%@分钟",result.needTime];
        self.totalDistanceL.text = [NSString stringWithFormat:@"%.3f公里",[result.mileage floatValue]];
        
        NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",result.startTime];
        [mString insertString:@":" atIndex:2];
        self.departTimeL.text = [mString copy];
    } else if ([model isKindOfClass:[EBBoughtModel class]]){
        EBBoughtModel *bought = model;
        self.priceL.text = [NSString stringWithFormat:@"￥%@元",bought.tradePrice];

        self.departPointL.text = bought.onStationName;
        self.endPointL.text = bought.offStationName;
        self.totalTimeL.text = [NSString stringWithFormat:@"%@分钟",bought.needTime];
        self.totalDistanceL.text = [NSString stringWithFormat:@"%.3f公里",[bought.mileage floatValue]];
        
        NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",bought.startTime];
        [mString insertString:@":" atIndex:2];
        self.departTimeL.text = [mString copy];
    }
}

- (void)setUpUI:(id)model {
    if ([model isKindOfClass:[EBSearchResultModel class]]) {
        EBSearchResultModel *result = model;
        if (self.isShowBuyView) {
            NSInteger type = [result.openType integerValue];
            if (type == 1) {
                self.buyType = EBSearchBuyTypeOfBuy;
            } else if (type == 2) {
                self.buyType = EBSearchBuyTypeOfSign;
            } else if (type == 3) {
                self.buyType = EBSearchBuyTypeOfGroup;
            } else {
                self.buyType = EBSearchBuyTypeOfNone;
            }
        }
    } else if ([model isKindOfClass:[EBBoughtModel class]]){
        
    }
    
}


- (void)setBuyType:(EBSearchBuyType)buyType {
    _buyType = buyType;
    UIColor *btnBackgroundColor = nil;
    NSString *btnTitle = nil;
    switch (buyType) {
        case EBSearchBuyTypeOfBuy:
            btnBackgroundColor = EB_BuyColor;
            btnTitle = @"购";
            break;
        case EBSearchBuyTypeOfGroup:
            btnBackgroundColor = EB_GroupColor;
            btnTitle = @"组团";
            break;
        case EBSearchBuyTypeOfSign:
            btnBackgroundColor = EB_SignColor;
            btnTitle = @"报";
            break;
        case EBSearchBuyTypeOfNone:
            
            break;
        default:
            break;
    }
    [self.buyBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.buyBtn setBackgroundColor:btnBackgroundColor];
    self.accessoryView = self.buyBtn;
}

#pragma mark - method
- (NSAttributedString *)attributedString:(NSString *)price {
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:price
                                  attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5bcec0"],
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#5bcec0"]}];
    return attrStr;
}

@end







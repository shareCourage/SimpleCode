//
//  EBMyOrderCell.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderCell.h"
#import "EBMyOrderModel.h"
#import <Masonry/Masonry.h>

@interface EBMyOrderCell ()

@property (nonatomic, weak) UIView *priceView;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UILabel *payWayL;
@end

@implementation EBMyOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EBMyOrderCell";
    EBMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *strickOut = [[UILabel alloc] init];
    strickOut.textColor = EB_RGBColor(114, 114, 114);
    strickOut.font = [UIFont systemFontOfSize:11];
    price.textAlignment = NSTextAlignmentRight;
    strickOut.textAlignment = NSTextAlignmentRight;
    price.text = @"price";
    strickOut.text = @"strick";
    
    [priceView addSubview:price];
    [priceView addSubview:strickOut];
    [self.contentView addSubview:priceView];
    self.priceView = priceView;
    self.priceL = price;
    self.payWayL = strickOut;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    EB_WS(ws);
    CGFloat right = 20;
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.height.mas_equalTo(@(50));//高度
        make.width.mas_equalTo(@(50));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-right);//离父控件右边
    }];
    
    
    CGFloat priceW = 60;
    CGFloat priceH = 30;
    CGFloat priceX = 0;
    CGFloat priceY = self.payWayL.hidden ? 10 : 0;
    self.priceL.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat strickoutPriceW = 60;
    CGFloat strickoutPriceH = 20;
    CGFloat strickoutPriceX = 0;
    CGFloat strickoutPriceY = CGRectGetMaxY(self.priceL.frame);
    self.payWayL.frame = CGRectMake(strickoutPriceX, strickoutPriceY, strickoutPriceW, strickoutPriceH);

}

- (void)setModel:(EBBaseModel *)model {
    [super setModel:model];
    if ([model isKindOfClass:[EBMyOrderModel class]]) {
        EBMyOrderModel *orderModel = (EBMyOrderModel *)model;
        [self setupUI:orderModel];
        [self setupData:orderModel];
    }
}

- (void)setupUI:(EBMyOrderModel *)orderModel {
    
}

- (void)setupData:(EBMyOrderModel *)orderModel {
    self.priceL.text = [NSString stringWithFormat:@"￥%@元",orderModel.originalPrice];
    NSInteger payType = [orderModel.payType integerValue];
    self.payWayL.text = [EBTool stringFromPayType:payType];
}

@end

//
//  EBMyOrderHeaderView.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderHeaderView.h"
#import "EBMyOrderModel.h"

@interface EBMyOrderHeaderView ()

@property (nonatomic, weak) UIImageView *titleImageView;
@property (nonatomic, weak) UILabel *orderL;
@property (nonatomic, weak) UILabel *rightL;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation EBMyOrderHeaderView

+ (EBMyOrderHeaderView *)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EBMyOrderHeaderView";
    EBMyOrderHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {
        header = [[EBMyOrderHeaderView alloc] initWithReuseIdentifier:ID];
    }
    header.contentView.backgroundColor = [UIColor whiteColor];
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.image = [UIImage imageNamed:@"me_myOrder_title"];
        [self.contentView addSubview:imageV];
        self.titleImageView = imageV;
        
        UILabel *order = [[UILabel alloc] init];
        order.textAlignment = NSTextAlignmentLeft;
        [order setSystemFontOf14];
        [self.contentView addSubview:order];
        self.orderL = order;
        
        UILabel *right = [[UILabel alloc] init];
        right.textAlignment = NSTextAlignmentRight;
        [right setSystemFontOf16];
        [self.contentView addSubview:right];
        self.rightL = right;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = EB_RGBColor(238, 238, 244);
//        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        self.layer.borderColor = EB_RGBColor(238, 238, 244).CGColor;
        self.layer.borderWidth = 1.f;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageX = 5;
    CGFloat imageY = 0;
    CGFloat imageW = 30;
    CGFloat imageH = 40;
    CGRect imageF = CGRectMake(imageX, imageY, imageW, imageH);
    self.titleImageView.frame = imageF;
    
    CGFloat orderX = CGRectGetMaxX(self.titleImageView.frame);
    CGFloat orderY = 0;
    CGFloat orderW = 200;
    CGFloat orderH = 40;
    CGRect orderF = CGRectMake(orderX, orderY, orderW, orderH);
    self.orderL.frame = orderF;
    
    CGFloat rightY = 0;
    CGFloat rightW = 100;
    CGFloat rightH = 40;
    CGFloat rightX = self.width - rightW - 5;
    CGRect rightF = CGRectMake(rightX, rightY, rightW, rightH);
    self.rightL.frame = rightF;
    
    CGFloat lineX = 0;
    CGFloat lineW = self.width;
    CGFloat lineH = 1;
    CGFloat lineY = self.height - lineH;
    CGRect lineF = CGRectMake(lineX, lineY, lineW, lineH);
    self.lineView.frame = lineF;
}

- (void)setOrderModel:(EBMyOrderModel *)orderModel {
    _orderModel = orderModel;
    self.orderL.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.mainNo];
    NSInteger payType = [orderModel.payType integerValue];
    NSInteger status = [orderModel.status integerValue];
    NSString *string = nil;
    if (payType == 3) {
        string = @"深圳通预订";
        if (status == 1) {
            string = @"已取消";
        } else if (status == 3) {
            string = @"已退票";
        }
    } else if (payType == 4) {
        string = @"免费证件";
        if (status == 3) {
            string = @"已退票";
        }
    } else {
        string = [EBTool stringFromStatus:status];
    }
    self.rightL.text = string;
}


@end












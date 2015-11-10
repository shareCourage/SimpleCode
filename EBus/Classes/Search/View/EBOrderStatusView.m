//
//  EBOrderStatusView.m
//  EBus
//
//  Created by Kowloon on 15/11/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBOrderStatusView.h"
#import "EBOrderDetailModel.h"

@interface EBOrderStatusView ()

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@property (weak, nonatomic) IBOutlet UILabel *payPrice;

@property (weak, nonatomic) IBOutlet UILabel *payWay;

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@end

@implementation EBOrderStatusView

+ (instancetype)orderStatusViewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

- (void)setOrderModel:(EBOrderDetailModel *)orderModel {
    _orderModel = orderModel;
    if (orderModel) {
        self.originalPrice.text = [NSString stringWithFormat:@"原价：%@元",orderModel.originalPrice];
        self.payPrice.text = [NSString stringWithFormat:@"实付款：%@元",orderModel.tradePrice];
        NSString *payTypeStr = [EBTool stringFromPayType:[orderModel.payType integerValue]];
        self.payWay.text = [NSString stringWithFormat:@"支付方式：%@",payTypeStr];
        self.orderNumber.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.mainNo];
        self.orderTime.text = [NSString stringWithFormat:@"下单时间：%@",orderModel.orderTime];
    }
}

- (void)awakeFromNib {
//    self.originalPrice.textColor = EB_RGBColor(246, 246, 246);
//    self.payPrice.textColor = EB_RGBColor(246, 246, 246);
//    self.payWay.textColor = EB_RGBColor(246, 246, 246);
//    self.orderNumber.textColor = EB_RGBColor(246, 246, 246);
//    self.orderTime.textColor = EB_RGBColor(246, 246, 246);
}

@end





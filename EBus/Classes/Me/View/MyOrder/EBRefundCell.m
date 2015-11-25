//
//  EBRefundCell.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBRefundCell.h"
#import "EBRefundModel.h"

@interface EBRefundCell ()
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation EBRefundCell

#pragma mark - Public Method

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.frame = CGRectMake(0, 0, 20, 20);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setBackgroundImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_selectHL"] forState:UIControlStateSelected];
        self.accessoryView = btn;
        self.selectedBtn = btn;
        self.detailTextLabel.textColor = [UIColor blackColor];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBRefundCell";
    EBRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBRefundCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setRefundModel:(EBRefundModel *)refundModel {
    _refundModel = refundModel;
    self.textLabel.text = refundModel.sale;
    self.detailTextLabel.text = @"已支付";
}

- (void)setRefundCellSelected:(BOOL)refundCellSelected {
    _refundCellSelected = refundCellSelected;
    self.selectedBtn.selected = refundCellSelected;
}

@end

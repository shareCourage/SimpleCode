//
//  EBRefundCell.h
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBRefundModel;

@interface EBRefundCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) EBRefundModel *refundModel;
@property (nonatomic, assign, getter=isRefundCellSelected) BOOL refundCellSelected;

@end

//
//  EBRefundCell.h
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBSecondList;

@interface EBRefundCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) EBSecondList *seclModel;
@property (nonatomic, assign, getter=isRefundCellSelected) BOOL refundCellSelected;

@end

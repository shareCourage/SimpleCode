//
//  EBRefundCell.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBRefundCell.h"

@implementation EBRefundCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBRefundCell";
    EBRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBRefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end

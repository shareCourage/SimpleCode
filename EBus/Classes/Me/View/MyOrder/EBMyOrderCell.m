//
//  EBMyOrderCell.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMyOrderCell.h"

@implementation EBMyOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EBMyOrderCell";
    EBMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end

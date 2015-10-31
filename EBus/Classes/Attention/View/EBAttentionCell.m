//
//  EBAttentionCell.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAttentionCell.h"

@implementation EBAttentionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EBAttentionCell";
    EBAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(id)model {
    [super setModel:model];
    _model = model;
}

@end

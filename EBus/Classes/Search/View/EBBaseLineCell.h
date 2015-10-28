//
//  EBBaseLineCell.h
//  EBus
//
//  Created by Kowloon on 15/10/15.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBBaseLineCell : UITableViewCell
{
    id _model;
}
@property (nonatomic, weak) UILabel *departTimeL;
@property (nonatomic, weak) UILabel *totalDistanceL;
@property (nonatomic, weak) UILabel *totalTimeL;
@property (nonatomic, weak) UILabel *departPointL;
@property (nonatomic, weak) UILabel *endPointL;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) id model;

@end

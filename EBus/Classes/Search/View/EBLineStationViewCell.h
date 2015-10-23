//
//  EBLineStationViewCell.h
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBLineStation;

@interface EBLineStationViewCell : UITableViewCell

@property (nonatomic, strong) EBLineStation *station;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

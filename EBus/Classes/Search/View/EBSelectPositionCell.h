//
//  EBSelectPositionCell.h
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBSelectPositionModel;
@class EBSelectPositionCell;
@class AMapPOI;

@protocol EBSelectPositionCellDelegate <NSObject>

@optional
- (void)selectPositionSureClick:(EBSelectPositionCell *)selectPositionCell title:(NSString *)title coord:(CLLocationCoordinate2D)coord;

@end

@interface EBSelectPositionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) IBOutlet id <EBSelectPositionCellDelegate>delegate;
@property (nonatomic, strong) EBSelectPositionModel *selectModel;

@end

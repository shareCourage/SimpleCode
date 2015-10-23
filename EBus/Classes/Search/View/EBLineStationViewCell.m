//
//  EBLineStationViewCell.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineStationViewCell.h"
#import "EBLineStation.h"

@interface EBLineStationViewCell ()

@property (nonatomic, weak) UIView *paddingView;

@end

@implementation EBLineStationViewCell

- (void)setStation:(EBLineStation *)station {
    _station = station;
    self.textLabel.text = station.station;
    self.detailTextLabel.text = @"07:00出发";
    NSString *imageString = nil;
    if (station.isOn) {
        if (station.isFirstOrEnd) {
            imageString = @"search_cell_start";
        } else {
            imageString = @"search_map_departPass";
        }
    } else {
        if (station.isFirstOrEnd) {
            imageString = @"search_cell_end";
        } else {
            imageString = @"search_map_endPass";
        }
    }
    self.imageView.image = [UIImage imageNamed:imageString];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBLineStationViewCell";
    EBLineStationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBLineStationViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = EB_RGBColor(250, 254, 246);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIView *paddingView = [[UIView alloc] init];
        paddingView.backgroundColor = EB_RGBColor(217, 217, 217);
//        [self addSubview:paddingView];
        self.paddingView = paddingView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.paddingView.center = self.imageView.center;
    self.paddingView.width = 2;
    self.paddingView.y = 0;
    self.paddingView.height = self.height + 2;
}

@end

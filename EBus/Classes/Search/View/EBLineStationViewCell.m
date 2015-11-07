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
    NSString *titleText = nil;
    NSUInteger lengthAA = 8;
    if (self.width > 320) {
        lengthAA = 11;
    } else {
        lengthAA = 8;
    };
    if (station.station.length > lengthAA) {//大于8个字符的，就进行拼接
        titleText = [station.station substringWithRange:NSMakeRange(0, lengthAA)];
        titleText = [titleText stringByAppendingString:@".."];
    } else {
        titleText = station.station;
    }
    self.textLabel.text = titleText;
    
    NSString *imageString = nil;
    if (station.isOn) {
        if (station.isFirstOrEnd) {
            imageString = @"search_cell_start";
        } else {
            imageString = @"search_map_departPass";
        }
        self.detailTextLabel.text = [NSString stringWithFormat:@"约%@",[station.time insertSymbolString:@":" atIndex:2]];
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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [EB_RGBColor(250, 254, 246) colorWithAlphaComponent:0.7f];
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

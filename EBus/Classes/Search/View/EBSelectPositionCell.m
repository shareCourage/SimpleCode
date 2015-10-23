//
//  EBSelectPositionCell.m
//  EBus
//
//  Created by Kowloon on 15/10/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSelectPositionCell.h"
#import "EBSelectPositionModel.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface EBSelectPositionCell ()

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

@end

@implementation EBSelectPositionCell

- (UIButton *)sureBtn {
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, 0, 50, 25);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.borderWidth = 1;
        _sureBtn.layer.borderColor = [UIColor redColor].CGColor;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(selectPositionSureClick:title:coord:)]) {
        [self.delegate selectPositionSureClick:self title:self.mainTitle coord:self.coord];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EBSelectPositionCell";
    EBSelectPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EBSelectPositionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelectModel:(EBSelectPositionModel *)selectModel {
    _selectModel = selectModel;
    [self setUpData:selectModel];
    [self setUpUI:selectModel];
}

- (void)setUpData:(EBSelectPositionModel *)selectModel {
    if (selectModel.regeocode) {
        AMapReGeocode *regeocode = selectModel.regeocode;
        AMapPOI *poi = [regeocode.pois firstObject];
        self.textLabel.text = [NSString stringWithFormat:@"[我的位置]%@",poi.name];
        self.detailTextLabel.text = regeocode.formattedAddress;
        
        self.coord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        self.mainTitle = poi.name;
        
    } else {
        AMapPOI *poi = selectModel.poi;
        self.textLabel.text = poi.name;
        self.detailTextLabel.text = poi.address;
        
        self.coord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        self.mainTitle = poi.name;
    }
}

- (void)setUpUI:(EBSelectPositionModel *)selectModel {
    if (selectModel.isSelected) {
        self.accessoryView = self.sureBtn;
    } else {
        self.accessoryView = nil;
    }
}

@end





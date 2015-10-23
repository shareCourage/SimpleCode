//
//  PHTableViewCell.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTableViewCell.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
@interface PHTableViewCell ()

/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;

/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation PHTableViewCell

//@synthesize switchView = _switchView;

- (UIImageView *)arrowView
{
    if (self.arrowViewName.length != 0) {
        if (_arrowView == nil) {
            _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.arrowViewName]];
        }
    }
    return _arrowView;
}
- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange
{
    [[NSUserDefaults standardUserDefaults] setBool:self.switchView.isOn forKey:self.phItem.title];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    PHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setPhItem:(PHSettingItem *)phItem
{
    _phItem = phItem;
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}
/**
 *  设置数据
 */
- (void)setupData
{
    if (self.phItem.icon) {
        self.imageView.image = [UIImage imageNamed:self.phItem.icon];
    }
    self.textLabel.text = self.phItem.title;
    self.detailTextLabel.text = self.phItem.subtitle;
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if ([self.phItem isKindOfClass:[PHSettingArrowItem class]]) { // 箭头
        if (self.arrowView) {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.accessoryView = self.arrowView;
        } else {
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if ([self.phItem isKindOfClass:[PHSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置开关的状态
        self.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.phItem.title];
    }
    else if ([self.phItem isKindOfClass:[PHSettingItem class]])//最初状态
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {//防止复用问题
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

@end






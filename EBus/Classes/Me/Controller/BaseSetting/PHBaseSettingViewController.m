//
//  PHBaseSettingViewController.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHBaseSettingViewController.h"
#import "PHSettingGroup.h"
#import "PHTableViewCell.h"

#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
@interface PHBaseSettingViewController ()

@end

@implementation PHBaseSettingViewController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PHSettingGroup *group = self.dataSource[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHTableViewCell *cell = [PHTableViewCell cellWithTableView:tableView];
    PHSettingGroup *group = self.dataSource[indexPath.section];
    cell.phItem = group.items[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    PHSettingGroup *group = self.dataSource[indexPath.section];
    PHSettingItem *setItem = group.items[indexPath.row];
    
    if (setItem.option)
    { // block有值(点击这个cell,.有特定的操作需要执行)
        setItem.option();
    }
    else if ([setItem isKindOfClass:[PHSettingArrowItem class]])
    { // 箭头
        PHSettingArrowItem *arrowItem = (PHSettingArrowItem *)setItem;
        [self pushVCWithClass:arrowItem.destVcClass settintItem:arrowItem];
    }
}
- (void)pushVCWithClass:(Class)destClass settintItem:(PHSettingItem *)item
{
    // 如果没有需要跳转的控制器
    if (destClass == nil) return;
    UIViewController *vc = [[destClass alloc] init];
    vc.title = item.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PHSettingGroup *group = self.dataSource[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    PHSettingGroup *group = self.dataSource[section];
    return group.footer;
}

@end

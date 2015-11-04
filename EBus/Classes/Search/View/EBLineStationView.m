//
//  EBLineStationView.m
//  EBus
//
//  Created by Kowloon on 15/10/22.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineStationView.h"
#import <Masonry/Masonry.h>
#import "EBLineStation.h"
#import "EBLineStationViewCell.h"

@interface EBLineStationView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation EBLineStationView

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - Super Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [EB_RGBColor(250, 254, 246) colorWithAlphaComponent:0.5f];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBLineStationViewCell *cell = [EBLineStationViewCell cellWithTableView:tableView];
    EBLineStation *station = self.dataSource[indexPath.row];
    cell.station = station;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EBLineStation *station = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(lineStationView:didSelectMode:)]) {
        [self.delegate lineStationView:self didSelectMode:station];
    }
}

@end



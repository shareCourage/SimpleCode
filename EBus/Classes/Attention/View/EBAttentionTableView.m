//
//  EBAttentionTableView.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBAttentionTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "EBBaseLineCell.h"
#import "EBAttentionCell.h"

@interface EBAttentionTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@end

@implementation EBAttentionTableView

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count == 0) {
        self.backgroundImageView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.backgroundImageView.hidden = YES;
    }
}
#pragma mark - Super
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        EB_WS(ws);
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws tableViewRefresh];
        }];
        self.tableView = tableView;
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.contentMode = UIViewContentModeCenter;
        UIImage *image = [UIImage imageNamed:@"main_background"];
        backgroundImageView.image = image;
        tableView.backgroundView = backgroundImageView;
        self.backgroundImageView = backgroundImageView;
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

#pragma mark - Public Method
- (void)beginRefresh {
    [self.tableView.header beginRefreshing];
}

#pragma mark - Private Method
- (void)tableViewRefresh {
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBBaseLineCell *cell = nil;
    switch (self.tag) {
        case EBAttentionTypePurchase:
            cell = [EBBaseLineCell cellWithTableView:tableView];
            break;
        case EBAttentionTypeSign | EBAttentionTypeGroup | EBAttentionTypeSponsor:
            cell = [EBAttentionCell cellWithTableView:tableView];
            break;
        default:
            break;
    }
    return cell;
}

@end

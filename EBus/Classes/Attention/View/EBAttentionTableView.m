//
//  EBAttentionTableView.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//
#import "EBAttentionTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "EBUsualLineCell.h"
#import "EBAttentionCell.h"
#import "EBUserInfo.h"

#import "EBBoughtModel.h"
#import "EBSignModel.h"
#import "EBGroupModel.h"
#import "EBSponsorModel.h"

@interface EBAttentionTableView () <UITableViewDataSource, UITableViewDelegate>
{
    NSUInteger _pageNumber;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation EBAttentionTableView

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Super
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageNumber = 1;
        self.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        EB_WS(ws);
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageNumber = 1;
            [ws xl_tableViewRefresh];
        }];
        tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            [ws sl_tableViewRefresh];
        }];
        tableView.footer.hidden = YES;
        self.tableView = tableView;
        UIImageView *backgroundImageView = [EBTool backgroundImageView];
        tableView.backgroundView = backgroundImageView;
        self.backgroundImageView = backgroundImageView;
    }
    return self;
}

- (void)attentionTableViewDidAppear {
    _pageNumber = 1;
    [self xl_tableViewRefresh];
    [self.tableView scrollsToTop];
}

- (void)attentionTableViewDidDisAppear {
    
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

#pragma mark - Public Method
- (void)beginRefresh {
    [self.tableView.header beginRefreshing];
}

#pragma mark - Private Method
- (void)xl_tableViewRefresh {//下拉
    if ([EBTool loginEnable]) {
        [self xl_request:[self urlOfRefresh]];
        self.refresh = YES;
    } else {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        self.backgroundImageView.hidden = NO;
        [self.tableView.header endRefreshing];
        self.refresh = NO;
    }
}

- (void)sl_tableViewRefresh {//上拉
    if ([EBTool loginEnable]) {
        [self sl_request:[self urlOfRefresh]];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag == EBAttentionTypePurchase) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBBoughtModel *bought = self.dataSource[indexPath.row];
        cell.model = bought;
        return cell;
    } else if (self.tag == EBAttentionTypeSign) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBSignModel *sign = self.dataSource[indexPath.row];
        cell.model = sign;
        return cell;
    } else if (self.tag == EBAttentionTypeGroup) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBGroupModel *group = self.dataSource[indexPath.row];
        cell.model = group;
        return cell;
    } else if (self.tag == EBAttentionTypeSponsor) {
        EBAttentionCell *cell = [EBAttentionCell cellWithTableView:tableView];
        EBSponsorModel *sponsor = self.dataSource[indexPath.row];
        cell.model = sponsor;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tag == EBAttentionTypePurchase) {
        EBBoughtModel *bought = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypePurchase:)]) {
            [self.delegate eb_tableView:self didSelectOfTypePurchase:bought];
        }
    } else if (self.tag == EBAttentionTypeSign) {
        EBSignModel *sign = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypeSign:)]) {
            [self.delegate eb_tableView:self didSelectOfTypeSign:sign];
        }
    } else if (self.tag == EBAttentionTypeGroup) {
        EBGroupModel *group = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypeGroup:)]) {
            [self.delegate eb_tableView:self didSelectOfTypeGroup:group];
        }
    } else if (self.tag == EBAttentionTypeSponsor) {
        EBSponsorModel *sponsor = self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(eb_tableView:didSelectOfTypeSponsor:)]) {
            [self.delegate eb_tableView:self didSelectOfTypeSponsor:sponsor];
        }
    }
}

#pragma mark - Network Request
- (void)xl_request:(NSString *)url {
    if (!url) {
        [self.tableView.header endRefreshing];
        return;
    }
    [EBNetworkRequest GET:url parameters:[self parametersOfRefresh] dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        NSArray *array = dict[static_Argument_returnData];
        for (NSDictionary *dict in array) {
            if (self.tag == EBAttentionTypePurchase) {
                EBBoughtModel *bought = [[EBBoughtModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeSign) {
                EBSignModel *bought = [[EBSignModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeGroup) {
                EBGroupModel *bought = [[EBGroupModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeSponsor) {
                EBSponsorModel *bought = [[EBSponsorModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            }
        }
        if (self.dataSource.count == 0) {
            self.tableView.footer.hidden = YES;
            self.backgroundImageView.hidden = NO;
        } else {
            if (self.dataSource.count >= EB_pageSize) {
                self.tableView.footer.hidden = NO;
            }
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)sl_request:(NSString *)url {
    if (!url) {
        [self.tableView.footer endRefreshing];
        return;
    }
    [EBNetworkRequest GET:url parameters:[self parametersOfRefresh] dictBlock:^(NSDictionary *dict) {
        EBLog(@"%@", dict);
        [self.tableView.footer endRefreshing];
        NSArray *array = dict[static_Argument_returnData];
        if (array.count == 0) {
            return;
        }
        for (NSDictionary *dict in array) {
            if (self.tag == EBAttentionTypePurchase) {
                EBBoughtModel *bought = [[EBBoughtModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeSign) {
                EBSignModel *bought = [[EBSignModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeGroup) {
                EBGroupModel *bought = [[EBGroupModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            } else if (self.tag == EBAttentionTypeSponsor) {
                EBSponsorModel *bought = [[EBSponsorModel alloc] initWithDict:dict];
                [self.dataSource addObject:bought];
            }
        }
        if (self.dataSource.count == 0) {
            self.backgroundImageView.hidden = NO;
        } else {
            self.backgroundImageView.hidden = YES;
        }
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}


- (NSString *)urlOfRefresh {
    NSString *url = nil;
    switch (self.tag) {
        case EBAttentionTypePurchase:
            url = static_Url_AttentionOfBought;
            break;
        case EBAttentionTypeSign:
            url = static_Url_AttentionOfSign;
            break;
        case EBAttentionTypeGroup:
            url = static_Url_AttentionOfGroup;
            break;
        case EBAttentionTypeSponsor:
            url = static_Url_AttentionOfSponsor;
            break;
        default:
            break;
    }
    return url;
}
- (NSDictionary *)parametersOfRefresh {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.tag == EBAttentionTypePurchase) {
        if ([EBUserInfo sharedEBUserInfo].loginName) {
            [parameters setObject:[EBUserInfo sharedEBUserInfo].loginName forKey:static_Argument_userName];
        }
        if ([EBUserInfo sharedEBUserInfo].loginId) {
            [parameters setObject:[EBUserInfo sharedEBUserInfo].loginId forKey:static_Argument_userId];
        }
    } else {
        if ([EBUserInfo sharedEBUserInfo].loginName) {
            [parameters setObject:[EBUserInfo sharedEBUserInfo].loginName forKey:static_Argument_customerName];
        }
        if ([EBUserInfo sharedEBUserInfo].loginId) {
            [parameters setObject:[EBUserInfo sharedEBUserInfo].loginId forKey:static_Argument_customerId];
        }
    }
    [parameters setObject:@(_pageNumber) forKey:static_Argument_pageNo];
    [parameters setObject:@(EB_pageSize) forKey:static_Argument_pageSize];
    return parameters;
}
@end

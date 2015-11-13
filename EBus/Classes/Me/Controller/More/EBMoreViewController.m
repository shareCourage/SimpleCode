//
//  EBMoreViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMoreViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
#import "EBMoreModel.h"
#import "EBMoreDetailController.h"

@interface EBMoreViewController ()

@end

@implementation EBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self moreRequest];
}

- (void)moreRequest {
    [EBNetworkRequest GET:static_Url_MoreList parameters:nil dictBlock:^(NSDictionary *dict) {
        NSArray *datas = dict[static_Argument_returnData];
        if (datas.count == 0) return;
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *obj in datas) {
            EBMoreModel *more = [[EBMoreModel alloc] initWithDict:obj];
            [mArray addObject:more];
        }
        [self one:[mArray copy]];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)one:(NSArray *)source {
    EB_WS(ws);
    NSMutableArray *items = [NSMutableArray array];
    for (EBMoreModel *more in source) {
        PHSettingItem *one = [PHSettingArrowItem itemWithTitle:more.title destVcClass:nil];
        one.option = ^{
            EBMoreDetailController *detail = [[EBMoreDetailController alloc] init];
            detail.moreModel = more;
            [ws.navigationController pushViewController:detail animated:YES];
        };
        [items addObject:one];
    }
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = [items copy];
    [self.dataSource addObject:group];
    [self.tableView reloadData];
}

@end



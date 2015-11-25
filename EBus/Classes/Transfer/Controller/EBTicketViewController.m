//
//  EBTicketViewController.m
//  EBus
//
//  Created by Kowloon on 15/11/25.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTicketViewController.h"
#import "EBBaseLineCell.h"
#import "EBTransferModel.h"
#import "EBTransferTipView.h"

@interface EBTicketViewController ()
@property (nonatomic, weak) UIView *footerView;
@property (nonatomic, weak) EBTransferTipView *tipView;
@end

@implementation EBTicketViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self footerViewImplementation];
}

- (void)footerViewImplementation {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    EBTransferTipView *tipView = [EBTransferTipView transferTipViewFromXib];
    tipView.transferModel = self.transferModel;
    tipView.frame = footerView.bounds;
    tipView.hidden = YES;
    [footerView addSubview:tipView];
    self.tipView = tipView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBBaseLineCell *cell = [EBBaseLineCell cellWithTableView:tableView];
    cell.model = self.transferModel;
    return cell;
}

@end

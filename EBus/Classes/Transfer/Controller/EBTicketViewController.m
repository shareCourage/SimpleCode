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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出票";
    self.tableView.allowsSelection = NO;
    [self footerViewImplementation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:EBLoginSuccessNotification object:nil];
}
- (void)loginNotification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerViewImplementation {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen - 100 - EB_HeightOfNavigationBar - 30)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    EBTransferTipView *tipView = [EBTransferTipView transferTipViewFromXib];
    tipView.transferModel = self.transferModel;
    tipView.frame = footerView.bounds;
    [footerView addSubview:tipView];
    self.tipView = tipView;
}

#pragma mark - UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = [NSArray seprateString:self.transferModel.runDate characterSet:@"-"];
    if (array.count != 3) return nil;
    NSString *string = [NSString stringWithFormat:@"乘车日期：%@月%@日",array[1], array[2]];
    return string;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
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

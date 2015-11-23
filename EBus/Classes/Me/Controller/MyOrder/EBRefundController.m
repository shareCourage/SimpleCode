//
//  EBRefundController.m
//  EBus
//
//  Created by Kowloon on 15/11/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBRefundController.h"
#import "EBOrderSpecificModel.h"
#import "EBRefundCell.h"

@interface EBRefundController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
- (IBAction)refundClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *upL;
@property (weak, nonatomic) IBOutlet UILabel *downL;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation EBRefundController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setSpecificModel:(EBOrderSpecificModel *)specificModel {
    _specificModel = specificModel;
    if (specificModel.saleDates.length != 0) {
        NSArray *sales = [specificModel.saleDates componentsSeparatedByString:@","];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:sales];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat tvH = EB_HeightOfScreen - EB_HeightOfNavigationBar - 60;
    CGRect tvF = CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, tvH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}



- (IBAction)refundClick:(id)sender {
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBRefundCell *cell = [EBRefundCell cellWithTableView:tableView];
    
    return cell;
}



@end







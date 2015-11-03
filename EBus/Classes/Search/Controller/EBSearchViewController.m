//
//  EBSearchViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/14.
//  Copyright © 2015年 Goome. All rights reserved.
//
#import "AppDelegate.h"
#import "EBSearchViewController.h"
#import "EBSelectPositionController.h"
#import "EBSearchResultController.h"
#import "EBSearchBusView.h"
#import "EBUsualLineCell.h"
#import "EBSearchResultModel.h"
#import "EBHotView.h"
#import "EBHotLabel.h"
@interface EBSearchViewController () <EBSearchBusViewDelegate, EBUsualLineCellDelegate, EBHotViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) EBSearchBusView *searchBusView;
@property (nonatomic, weak) EBHotView *hotView;

@property (nonatomic, assign) CLLocationCoordinate2D myPositionCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endPositionCoord;

@end

@implementation EBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查询";
    self.tableView.allowsSelection = NO;
    self.myPositionCoord = kCLLocationCoordinate2DInvalid;
    self.endPositionCoord = kCLLocationCoordinate2DInvalid;
    [self searchBusViewImplementation];
    [self itemImplementation];
    [self hotViewImplementation];
}
- (void)searchBusViewImplementation {
    EBSearchBusView *searchBusView = [[EBSearchBusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    searchBusView.delegate = self;
    self.tableView.tableHeaderView = searchBusView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchBusView = searchBusView;
}
- (void)itemImplementation {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotBtn.frame = CGRectMake(0, 0, 40, 30);
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [hotBtn setTitle:@"HOT" forState:UIControlStateNormal];
    [hotBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [hotBtn addTarget:self action:@selector(hotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithCustomView:hotBtn];
    self.navigationItem.rightBarButtonItem = hotItem;
}

- (void)hotViewImplementation {
    EBHotView *hotView = [EBHotView hotViewFromXib];
    hotView.delegate = self;
    hotView.frame = CGRectMake(0, 0, EB_WidthOfScreen, EB_HeightOfScreen);
    hotView.hidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:hotView];
    self.hotView = hotView;
    [self hotLabelRequest];
}

- (void)hotLabelRequest {
    EB_WS(ws);
    [EBNetworkRequest GET:static_Url_HotLabel parameters:nil dictBlock:^(NSDictionary *dict) {
        NSArray *returnData = dict[static_Argument_returnData];
        NSMutableArray *hots = [NSMutableArray array];
        for (NSDictionary *obj in returnData) {
            EBHotLabel *hot = [[EBHotLabel alloc] initWithDict:obj];
            [hots addObject:hot];
        }
#ifdef DEBUG
        EBHotLabel *hot = [[EBHotLabel alloc] init];
        hot.name = @"haha";
        [hots addObject:hot];
#else
#endif
        ws.hotView.hots = [hots copy];
    } errorBlock:nil indicatorVisible:NO];
}

#pragma mark - Method
- (void)hotBtnClick {
    [UIView animateWithDuration:0.5f animations:^{
        self.hotView.hidden = !self.hotView.hidden;
    } completion:^(BOOL finished) {
        if (!self.hotView.hidden) {
            [self.view.window bringSubviewToFront:self.hotView];
        }
    }];  
}
#pragma mark - EBHotViewDelegate
- (void)hotView:(EBHotView *)hotView didSelectIndex:(NSUInteger)index hotLabel:(EBHotLabel *)hotLabel{
    EBLog(@"%ld, %@",(unsigned long)index, hotLabel.name);
    hotView.hidden = YES;
    EBSearchResultController *result = [[EBSearchResultController alloc] init];
    result.hotLabel = hotLabel;
    [self.navigationController pushViewController:result animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"常用路线";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBUsualLineCell *cell = [EBUsualLineCell cellWithTableView:tableView];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - EBUsualLineCellDelegate
- (void)usualLineDidClick:(EBUsualLineCell *)usualLine type:(EBSearchBuyType)type{
    EBLog(@"usualLineDidClick");
}

#pragma mark - EBSearchBusViewDelegate
- (void)searchBusView:(EBSearchBusView *)searchBusView clickType:(EBSearchBusClickType)type {
    switch (type) {
        case EBSearchBusClickTypeMyPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeEndPosition:
            [self selectPosition:type];
            break;
        case EBSearchBusClickTypeDeleteOfMyPosition:
            self.myPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeDeleteOfEndPosition:
            self.endPositionCoord = kCLLocationCoordinate2DInvalid;
            break;
        case EBSearchBusClickTypeSearch:
            [self searchSpecificBus];
            break;
        case EBSearchBusClickTypeExchange:
        {
            CLLocationCoordinate2D coord = self.myPositionCoord;
            self.myPositionCoord = self.endPositionCoord;
            self.endPositionCoord = coord;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Method
- (void)selectPosition:(EBSearchBusClickType)type {
    EB_WS(ws);
    EBSelectPositionController *selectC = [[EBSelectPositionController alloc] initWithOption:^(NSString *title, CLLocationCoordinate2D coord) {
        if (type == EBSearchBusClickTypeMyPosition) {
            ws.searchBusView.myPositionTitle = title;
            ws.myPositionCoord = coord;
        } else if (type == EBSearchBusClickTypeEndPosition) {
            ws.searchBusView.endPositionTitle = title;
            ws.endPositionCoord = coord;
        }
    }];
    [self.navigationController pushViewController:selectC animated:YES];
}

- (void)searchSpecificBus {
    BOOL my = CLLocationCoordinate2DIsValid(self.myPositionCoord);
    BOOL end = CLLocationCoordinate2DIsValid(self.endPositionCoord);
    if (my || end) {
        EBSearchResultController *result = [[EBSearchResultController alloc] init];
        result.myPositionCoord = self.myPositionCoord;
        result.endPositionCoord = self.endPositionCoord;
        [self.navigationController pushViewController:result animated:YES];
    }
}

@end





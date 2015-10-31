//
//  EBAttentionController.m
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define EB_HeightOfAttentionTitleView 50
#import "EBAttentionController.h"
#import "EBAttentionTitleView.h"
#import "EBAttentionTableView.h"
#import "EBUserInfo.h"

@interface EBAttentionController () <EBAttentionTitleViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) EBAttentionTitleView *titleView;
@property (nonatomic, weak) UIScrollView *tableScrollView;

@property (nonatomic, strong) NSMutableArray *tableViews;
@end

@implementation EBAttentionController
- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (void)setTitleSelectIndex:(NSUInteger)titleSelectIndex {
    _titleSelectIndex = titleSelectIndex;
    [self.titleView selectIndex:titleSelectIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    [self titleViewImplementation];
    [self scrollViewImplementation];
}
- (void)scrollViewImplementation {
    CGFloat scrollX = 0;
    CGFloat scrollY = EB_HeightOfNavigationBar + EB_HeightOfAttentionTitleView;
    CGFloat scrollW = EB_WidthOfScreen;
    CGFloat scrollH = EB_HeightOfScreen - scrollY - EB_HeightOfTabBar;
    CGRect scrollF = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollF];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(EB_WidthOfScreen * 4, scrollH);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    for (NSUInteger i = 0; i < 4 ; i ++) {
        CGFloat tableX = i * EB_WidthOfScreen;
        CGFloat tableY = 0;
        CGFloat tableW = EB_WidthOfScreen;
        CGFloat tableH = scrollH;
        CGRect tableF = CGRectMake(tableX, tableY, tableW, tableH);
        EBAttentionTableView *tableView = [[EBAttentionTableView alloc] initWithFrame:tableF];
        tableView.tag = i + EBAttentionTypePurchase;
        [scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        if (i == 0) {
            [tableView beginRefresh];
        }
    }
    [self.view addSubview:scrollView];
    self.tableScrollView = scrollView;
    
//    self.tableScrollView.contentOffset = CGPointMake(self.titleSelectIndex * scrollW, scrollH);
}

- (void)titleViewImplementation {
    EBAttentionTitleView *titleView = [[EBAttentionTitleView alloc] initWithFrame:CGRectMake(0, EB_HeightOfNavigationBar, EB_WidthOfScreen, EB_HeightOfAttentionTitleView)];
    titleView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    titleView.layer.borderWidth = 1.f;
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    NSArray *titleImages = @[@"Attention_buy",@"Attention_register",@"Attention_group",@"Attention_sponsor"];
    NSArray *titleImagesSel = @[@"Attention_buyHL",@"Attention_registerHL",@"Attention_groupHL",@"Attention_sponsorHL"];
    // 2.添加对应个数的按钮
    for (int i = 0; i < 4; i++) {
        NSString *name = titleImages[i];
        NSString *selName = titleImagesSel[i];
        [titleView addTitleButtonWithName:name selName:selName];
    }
    [titleView selectIndex:self.titleSelectIndex];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / EB_WidthOfScreen;
    [self.titleView selectIndex:index];
}

#pragma mark - EBAttentionTitleViewDelegate
- (void)titleView:(EBAttentionTitleView *)titleView didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to {
    EBLog(@"from %ld , to %ld",(unsigned long)from, (unsigned long)to);
    [self.tableScrollView setContentOffset:CGPointMake(to * EB_WidthOfScreen, 0) animated:YES];
    
}



@end







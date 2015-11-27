//
//  EBMyOrderTableView.h
//  EBus
//
//  Created by Kowloon on 15/11/10.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBMyOrderTableView, EBMyOrderCompletedModel, EBMyOrderUncompletedModel, EBMyOrderModel;

typedef  NS_ENUM(NSUInteger, EBMyOrderType) {
    EBMyOrderTypeOfCompleted = 1000,
    EBMyOrderTypeOfUncompleted,
};

@protocol EBMyOrderTableViewDelegate <NSObject>

@optional
- (void)mo_tableView:(EBMyOrderTableView *)tableView didSelectOfTypeCompleted:(EBMyOrderCompletedModel *)completed;
- (void)mo_tableView:(EBMyOrderTableView *)tableView didSelectOfTypeUnCompleted:(EBMyOrderUncompletedModel *)unCompleted;
- (void)mo_tableView:(EBMyOrderTableView *)tableView didSelect:(EBMyOrderModel *)orderModel;
@end

@interface EBMyOrderTableView : UIView


@property (nonatomic, weak) id <EBMyOrderTableViewDelegate> delegate;
@property (nonatomic, assign, getter = isRefreshed) BOOL refresh;

/*
 *下拉刷新
 */
- (void)beginRefresh;
/*
 *刷新数据，但没有下拉效果
 */
- (void)xl_tableViewRefresh;

- (void)myOrderTableViewDidAppear;
- (void)myOrderTableViewDidDisAppear;
@end

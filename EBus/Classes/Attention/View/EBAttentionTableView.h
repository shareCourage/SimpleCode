//
//  EBAttentionTableView.h
//  EBus
//
//  Created by Kowloon on 15/10/28.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBAttentionTableView, EBBoughtModel, EBSignModel, EBGroupModel, EBSponsorModel;

typedef  NS_ENUM(NSUInteger, EBAttentionType) {
    EBAttentionTypePurchase = 200,
    EBAttentionTypeSign,
    EBAttentionTypeGroup,
    EBAttentionTypeSponsor,
    EBAttentionTypeNone
};

@protocol EBAttentionTableViewDelegate <NSObject>

@optional
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypePurchase:(EBBoughtModel *)bough;
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypeSign:(EBSignModel *)sign;
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypeGroup:(EBGroupModel *)group;
- (void)eb_tableView:(EBAttentionTableView *)tableView didSelectOfTypeSponsor:(EBSponsorModel *)sponsor;
@end


@interface EBAttentionTableView : UIView

@property (nonatomic, assign) id <EBAttentionTableViewDelegate>delegate;

@property (nonatomic, assign, getter = isRefreshed) BOOL refresh;

/*
 *下拉刷新
 */
- (void)beginRefresh;
/*
 *刷新数据，但没有下拉效果
 */
- (void)xl_tableViewRefresh;

- (void)attentionTableViewDidAppear;
- (void)attentionTableViewDidDisAppear;
@end

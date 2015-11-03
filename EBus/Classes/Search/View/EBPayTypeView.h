//
//  EBPayTypeView.h
//  EBus
//
//  Created by Kowloon on 15/11/2.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBPayTypeView;

@protocol EBPayTypeViewDelegate <NSObject>

@optional
- (void)payTypeView:(EBPayTypeView *)titleView didSelectIndex:(NSUInteger)index;

@end


@interface EBPayTypeView : UIView

@property (nonatomic, weak) id <EBPayTypeViewDelegate> delegate;

- (void)addTitleButtonWithTitle:(NSString *)title imageName:(NSString *)name;
- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName;
- (void)addTitleButtonWithName:(NSString *)name selName:(NSString *)selName title:(NSString *)title;


@end

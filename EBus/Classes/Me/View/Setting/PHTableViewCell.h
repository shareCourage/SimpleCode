//
//  PHTableViewCell.h
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHSettingItem;

@interface PHTableViewCell : UITableViewCell

//@property (nonatomic, assign, getter = isCellStyleSubtitle)BOOL cellStyleSubtitle;

@property (nonatomic, copy) NSString *arrowViewName;

@property(nonatomic, strong)PHSettingItem *phItem;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  IntegralDetailTableViewHeaderCell.h
//  ZCPal
//
//  Created by Ky.storm on 14-8-27.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"

@interface IntegralDetailTableViewHeaderCell : UITableViewCell <UIExpandingTableViewCell>
@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
@property (nonatomic, assign, getter = isExpandable) BOOL expandable;
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;


@property (nonatomic, copy) NSString *count;        //数目
@property (nonatomic, copy) NSString *date;         //日期

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;

@end

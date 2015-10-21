//
//  mypublicListView.h
//  master
//
//  Created by jin on 15/8/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mypublicListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView*tableview;
@property(nonatomic)NSMutableArray*dataArray;//tableview数据源
@property(nonatomic,copy)void(^listDidSelect)(NSIndexPath*indexPath);
@property(nonatomic,copy)void(^deleBlock)(NSIndexPath*indexPath);
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property(nonatomic,weak)SDRefreshHeaderView *weakRefreshHeader;//下拉刷新透视图
@property(nonatomic,copy)refershBlock RefershBlock;//上拉刷新处理
@property(nonatomic)BOOL isRefersh;//是否是下拉刷新
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@property(nonatomic,copy)void(^pullUpBlock)();//上拉加载

@end

//
//  worksList.h
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#import "DOPDropDownMenu.h"
@interface worksList : UIView<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)DOPDropDownMenu*menue;
@property(nonatomic)NSMutableArray*firstArray;
@property(nonatomic)NSMutableArray*secondArray;
@property(nonatomic)NSMutableArray*thirdArray;
@property (nonatomic) RefershTableview *tableview;
@property(nonatomic)NSMutableArray*dataArray;//tableview数据源
@property(nonatomic,copy)void(^menueDidSelect)(DOPIndexPath*indexpath);//筛选菜单点击事件
@property(nonatomic,copy)void(^tableDidSelected)(UITableView*tableview,NSIndexPath*indexpath);
@property(nonatomic,copy)void(^personBlock)(BOOL isYesOrNo);
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

//
//  PeoCaseViewController.h
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface PeoCaseViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSMutableArray*picArray;//工程案例数据源
@property(nonatomic) NSInteger id; //用户id
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSInteger totalPage;
@property (nonatomic) UINavigationController *nav;

@end

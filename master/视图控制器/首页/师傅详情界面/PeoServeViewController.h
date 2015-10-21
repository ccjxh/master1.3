//
//  PeoServeViewController.h
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface PeoServeViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)NSMutableArray*recommendArray;//评论数据源
@property (nonatomic,assign) NSInteger id; //用户id
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSInteger totalPage;
@end

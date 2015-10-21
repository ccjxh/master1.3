//
//  CollectViewController.h
//  master
//
//  Created by xuting on 15/6/4.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface CollectViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSString*type;//名字后面的类型
@property(nonatomic)NSInteger currentPage;
@end

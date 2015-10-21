//
//  SetViewController.h
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface SetViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

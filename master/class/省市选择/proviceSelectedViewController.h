//
//  proviceSelectedViewController.h
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface proviceSelectedViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray*selectArray;//已选择数组
@end

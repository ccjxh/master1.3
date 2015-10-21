//
//  openCityManagerViewController.h
//  master
//
//  Created by jin on 15/10/12.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface openCityManagerViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;

@end

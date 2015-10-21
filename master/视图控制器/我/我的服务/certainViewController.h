//
//  certainViewController.h
//  master
//
//  Created by jin on 15/8/12.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface certainViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger id;
@property(nonatomic)BOOL isShow;
@property(nonatomic)NSIndexPath*currentIndexPath;

@end

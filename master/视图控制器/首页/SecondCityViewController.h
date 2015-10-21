//
//  SecondCityViewController.h
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface SecondCityViewController : RootViewController
@property(nonatomic)AreaModel*model;
@property(nonatomic)NSInteger count;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

//
//  CityTableViewController.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic,assign) NSInteger provinceId;
@property (nonatomic,assign) int flag;
@property (nonatomic,copy) NSString *content;

@end

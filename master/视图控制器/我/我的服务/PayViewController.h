//
//  PayViewController.h
//  master
//
//  Created by jin on 15/6/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface PayViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,copy)void(^expectBlock)();
@property(nonatomic,copy)void(^valuechange)(NSString*text,payModel*model);
@property(nonatomic)NSInteger type;//0为我的服务薪资期望  1为发布工作中的待遇
@end

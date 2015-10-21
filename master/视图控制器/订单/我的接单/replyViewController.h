//
//  replyViewController.h
//  master
//
//  Created by jin on 15/6/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface replyViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic) UITextView*tx;
@property(nonatomic)NSInteger id;//订单id
@property(nonatomic)NSInteger masterID;//雇主评论记录的ID
@end
